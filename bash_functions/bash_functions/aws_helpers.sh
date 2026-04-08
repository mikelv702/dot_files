alias awswhoami="aws sts get-caller-identity"
aws-list-ec2() {
    local region=${1:-us-west-2}
    aws ec2 describe-instances \
        --region "$region" \
        --query 'Reservations[].Instances[].[InstanceType, ImageId, InstanceId, Tags[?Key==`Name`].Value | [0]]' \
        --output table
}

aws-trail-ec2() {
    local region=${1:-us-west-2}
    local days_ago=${2:-1}
    local start_time
    local end_time

    end_time="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

    if date -v-1d > /dev/null 2>&1; then
        start_time="$(date -u -v-${days_ago}d +"%Y-%m-%dT%H:%M:%SZ")"
    else
        start_time="$(date -u -d "-${days_ago} days" +"%Y-%m-%dT%H:%M:%SZ")"
    fi

    aws cloudtrail lookup-events \
        --region "$region" \
        --lookup-attributes AttributeKey=EventName,AttributeValue=TerminateInstances \
        --start-time "$start_time" \
        --end-time "$end_time" \
        --query 'Events[].[EventTime,Username,EventName,EventSource]' \
        --output table
}


aws-trail-ec2-terminate() {
    local region=${1:-us-west-2}
    local days_ago=${2:-1}
    local start_time
    local end_time

    end_time="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

    if date -v-1d > /dev/null 2>&1; then
        start_time="$(date -u -v-${days_ago}d +"%Y-%m-%dT%H:%M:%SZ")"
    else
        start_time="$(date -u -d "-${days_ago} days" +"%Y-%m-%dT%H:%M:%SZ")"
    fi

    aws cloudtrail lookup-events \
        --region "$region" \
        --lookup-attributes AttributeKey=EventName,AttributeValue=TerminateInstances \
        --start-time "$start_time" \
        --end-time "$end_time" \
        --query 'Events[].CloudTrailEvent' \
        --output json | jq -r '.[] | fromjson |
            select(.eventName == "TerminateInstances") |
            . as $event |
            .requestParameters.instancesSet.items[] |
            [.instanceId,
             ($event.userIdentity.userName // $event.userIdentity.principalId // "N/A"),
             $event.eventTime] |
            @tsv' | column -t -s $'\t'
}

aws-trail-ec2-run-instance() {
    local region=${1:-us-west-2}
    local days_ago=${2:-1}
    declare resource_name=${3:-$(</dev/stdin)};
    local start_time
    local end_time
    echo $resource_name

    end_time="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

    if date -v-1d > /dev/null 2>&1; then
        start_time="$(date -u -v-${days_ago}d +"%Y-%m-%dT%H:%M:%SZ")"
    else
        start_time="$(date -u -d "-${days_ago} days" +"%Y-%m-%dT%H:%M:%SZ")"
    fi

    aws cloudtrail lookup-events \
        --region "$region" \
        --lookup-attributes AttributeKey=ResourceName,AttributeValue="$resource_name" \
        --start-time "$start_time" \
        --end-time "$end_time" \
        --query 'Events[].CloudTrailEvent' \
        --output json | jq -r '.[] | fromjson |
          select(.eventName == "RunInstances") |
            . as $event |
            .requestParameters.instancesSet.items[] |
            [.imageId,
             ($event.userIdentity.userName // $event.userIdentity.principalId // "N/A"),
             $event.requestParameters.instanceType,
             $event.eventTime] |
            @tsv' | column -t -s $'\t'
}

aws-trail-ec2-run() {
    local region=${1:-us-west-2}
    local days_ago=${2:-1}
    local start_time
    local end_time

    end_time="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

    if date -v-1d > /dev/null 2>&1; then
        start_time="$(date -u -v-${days_ago}d +"%Y-%m-%dT%H:%M:%SZ")"
    else
        start_time="$(date -u -d "-${days_ago} days" +"%Y-%m-%dT%H:%M:%SZ")"
    fi

    aws cloudtrail lookup-events \
        --region "$region" \
        --lookup-attributes AttributeKey=EventName,AttributeValue=RunInstances \
        --start-time "$start_time" \
        --end-time "$end_time" \
        --query 'Events[].CloudTrailEvent' \
        --output json | jq -r '.[] | fromjson |
          select(.eventName == "RunInstances") |
            . as $event |
            .responseElements.instancesSet.items[] |
            [
             .imageId,
             ($event.userIdentity.userName // $event.userIdentity.principalId // "N/A"),
             .instanceType,
             .instanceId,
             $event.eventTime
            ] |
            @tsv' | column -t -s $'\t'
}


aws-resource-explorer() {
    setopt interactivecomments
    local aws_region=${1:-us-east-1}
    local output_format=${2:-table}

    echo "📊 Gathering AWS resources in region: $aws_region"
    echo "================================================"


    echo "\n🖥️  EC2 Instances:"
    aws ec2 describe-instances \
        --region $aws_region \
        --query 'Reservations[].Instances[].[InstanceId, InstanceType, State.Name, Tags[?Key==`Name`].Value | [0]]' \
        --output $output_format

    echo "\n💾 RDS Databases:"
    aws rds describe-db-instances \
        --region $aws_region \
        --query 'DBInstances[].[DBInstanceIdentifier, DBInstanceClass, Engine, DBInstanceStatus]' \
        --output $output_format

    echo "\n⚖️  Load Balancers:"
    aws elbv2 describe-load-balancers \
        --region $aws_region \
        --query 'LoadBalancers[].[LoadBalancerName, DNSName, State.Code]' \
        --output $output_format


    echo "\n📦 S3 Buckets:"
    aws s3api list-buckets \
        --query 'Buckets[].[Name, CreationDate]' \
        --output $output_format


    echo "\n⚡ Lambda Functions:"
    aws lambda list-functions \
        --region $aws_region \
        --query 'Functions[].[FunctionName, Runtime, MemorySize]' \
        --output $output_format


    echo "\n🐳 ECS Clusters:"
    aws ecs list-clusters \
        --region $aws_region \
        --query 'clusterArns[]' \
        --output $output_format


    echo "\n☸️  EKS Clusters:"
    aws eks list-clusters \
        --region $aws_region \
        --query 'clusters[]' \
        --output $output_format


    echo "\n📚 CloudFormation Stacks:"
    aws cloudformation list-stacks \
        --region $aws_region \
        --query 'StackSummaries[].[StackName,StackStatus]' \
        --output $output_format

    echo "\n💨 ElastiCache Clusters:"
    aws elasticache describe-cache-clusters \
        --region $aws_region \
        --query 'CacheClusters[].[CacheClusterId,Engine,CacheNodeType,CacheClusterStatus]' \
        --output $output_format
}