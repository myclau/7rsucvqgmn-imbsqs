

resource "aws_sqs_queue" "fifo_sqs_queue" {
  name                      = var.sqs_queue_name
  delay_seconds             = var.sqs_queue_delay_seconds
  max_message_size          = var.sqs_queue_max_message_size
  message_retention_seconds = var.sqs_queue_message_retention_seconds
  receive_wait_time_seconds = var.sqs_queue_receive_wait_time_seconds
  
  tags = {
    Project = var.project_name
  }
  fifo_queue                  = true
  content_based_deduplication = true
}
resource "aws_sqs_queue" "fifo_sqs_topic" {
  name                      = var.sqs_topic_name
  delay_seconds             = var.sqs_topic_delay_seconds
  max_message_size          = var.sqs_topic_max_message_size
  message_retention_seconds = var.sqs_topic_message_retention_seconds
  receive_wait_time_seconds = var.sqs_topic_receive_wait_time_seconds
  
  tags = {
    Project = var.project_name
  }
  fifo_queue                  = true
  content_based_deduplication = true
}

/*
resource "aws_cloudwatch_metric_alarm" "queue-depth-alarm" {
    alarm_name = "${var.sqs_queue_name}-queue-depth-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "ApproximateNumberOfMessagesVisible"
    namespace = "AWS/SQS"
    period = "60"
    statistic = "Sum"
    threshold = "5000"
    treat_missing_data = "notBreaching"
    dimensions = {
        QueueName = "${aws_sqs_queue.fifo_sqs_queue.name}"
    }

    alarm_description = "This metric monitors queue depth and send email with SNS accordingly."
    alarm_actions = [
        "${aws_sns_topic.queue_depth_alert_topic.arn}"
    ]
    ok_actions = [
        "${aws_sns_topic.queue_depth_alert_topic.arn}"
    ]
}
resource "aws_cloudwatch_metric_alarm" "topic-depth-alarm" {
    alarm_name = "${var.sqs_topic_name}-topic-depth-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "ApproximateNumberOfMessagesVisible"
    namespace = "AWS/SQS"
    period = "60"
    statistic = "Sum"
    threshold = "5000"
    treat_missing_data = "notBreaching"
    dimensions = {
        QueueName = "${aws_sqs_queue.fifo_sqs_topic.name}"
    }

    alarm_description = "This metric monitors topic depth and send email with SNS accordingly."
    alarm_actions = [
        "${aws_sns_topic.topic_depth_alert_topic.arn}"
    ]
    ok_actions = [
        "${aws_sns_topic.topic_depth_alert_topic.arn}"
    ]
}
*/