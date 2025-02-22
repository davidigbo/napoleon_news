class AnalyticsController < ApplicationController
  def index
    @article_metrics = {
      draft: Article.draft.size,
      under_review: Article.under_review.size,
      approved: Article.approved.size,
      published: Article.published.size
    }

    @user_metrics = {
      active: User.where(active: true).size,
      new: User.where(active: true, created_at: 7.days.ago .. Time.now).size,
      deactivated: User.where(active: false).size
    }

    weekly_counts = User.where("created_at >= ?", 6.months.ago)
      .group(Arel.sql("DATE_TRUNC('week', created_at)"))
      .order(Arel.sql("DATE_TRUNC('week', created_at)"))
      .count

    weekly_user_labels = weekly_counts.keys.map { |date| (date + 6.days).strftime("%b %d, %Y") } # Week ending
    weekly_user_data = weekly_counts.values
      
    @weekly_user_chart_data = {
      labels: weekly_user_labels,
      datasets: [{
        label: "Users",
        data: weekly_user_data,
        borderColor: "#007bff",
        fill: false
      }]
    }.to_json

    monthly_counts = User.where("created_at >= ?", 6.months.ago)
      .group(Arel.sql("DATE_TRUNC('month', created_at)"))
      .order(Arel.sql("DATE_TRUNC('month', created_at)"))
      .count

    monthly_user_labels = monthly_counts.keys.map { |date| date.strftime("%b %Y") } # "Feb 2024"
    monthly_user_data = monthly_counts.values

    @monthly_user_chart_data = {
      labels: monthly_user_labels,
      datasets: [{
        label: "Users",
        data: monthly_user_data,
        borderColor: "#007bff",
        fill: false
      }]
    }.to_json

    #Article Engagement Count
    weekly_engagement_counts = PageView
    .where(page_type: "article", created_at: 6.months.ago..Time.current)
    .group("DATE_TRUNC('week', created_at)")
    .select("DATE_TRUNC('week', created_at) AS week_start, COUNT(*) AS cumulative_page_views")
    .order("week_start")


      # debugger

    # weekly_engagement_labels = weekly_engagement_counts.keys.map { |date| (date + 6.days).strftime("%b %d, %Y") } # Week ending
    # weekly_engagement_data = weekly_engagement_counts.values
    weekly_engagement_labels = weekly_engagement_counts.map { |record| (record.week_start + 6.days).strftime("%b %d, %Y") } 
    weekly_engagement_data = weekly_engagement_counts.map(&:cumulative_page_views)

    @weekly_engagement_chart_data = {
      labels: weekly_engagement_labels,
      datasets: [{
        label: "Weekly Engagement (Unique Article Reads)",
        data: weekly_engagement_data,
        backgroundColor: "#007bff"
      }]
    }.to_json

    monthly_engagement_counts = PageView
      .where(page_type: "article", created_at: 6.months.ago..Time.current)
      .group("DATE_TRUNC('month', created_at)")
      .select("DATE_TRUNC('month', created_at) AS month_start, COUNT(*) AS cumulative_page_views")
      .order("month_start")

    # monthly_engagement_labels = monthly_engagement_counts.keys.map { |date| date.strftime("%b %Y") } # "Feb 2024"
    # monthly_engagement_data = monthly_engagement_counts.values
    monthly_engagement_labels = monthly_engagement_counts.map { |record| record.month_start.strftime("%b %Y") }
    monthly_engagement_data = monthly_engagement_counts.map(&:cumulative_page_views)

    @monthly_engagement_chart_data = {
      labels: monthly_engagement_labels,
      datasets: [{
        label: "Monthly Engagement (Unique Article Reads)",
        data: monthly_engagement_data,
        backgroundColor: "#28a745"
      }]
    }.to_json

    # Cummulative User Count
    weekly_user_counts = User
      .select(Arel.sql("DATE_TRUNC('week', created_at) AS week_start, COUNT(*) OVER (ORDER BY DATE_TRUNC('week', created_at) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_count"))
      .where("created_at >= ?", 6.months.ago)
      .group("week_start")
      .order("week_start")

    cumm_weekly_user_labels = weekly_user_counts.map { |row| (row.week_start + 6.days).strftime("%b %d, %Y") }
    cumm_weekly_user_data = weekly_user_counts.map(&:cumulative_count)

    @weekly_cumulative_user_chart_data = {
      labels: cumm_weekly_user_labels,
      datasets: [{
        label: "Cumulative Users (Weekly)",
        data: cumm_weekly_user_data,
        borderColor: "#007bff",
        fill: false
      }]
    }.to_json

    monthly_user_counts = User
      .select(Arel.sql("DATE_TRUNC('month', created_at) AS month_start, COUNT(*) OVER (ORDER BY DATE_TRUNC('month', created_at) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_count"))
      .where("created_at >= ?", 6.months.ago)
      .group("month_start")
      .order("month_start")

    cumm_monthly_user_labels = monthly_user_counts.map { |row| row.month_start.strftime("%b %Y") }
    cumm_monthly_user_data = monthly_user_counts.map(&:cumulative_count)

    @monthly_cumulative_user_chart_data = {
      labels: cumm_monthly_user_labels,
      datasets: [{
        label: "Cumulative Users (Monthly)",
        data: cumm_monthly_user_data,
        borderColor: "#28a745",
        fill: false
      }]
    }.to_json
  end
end