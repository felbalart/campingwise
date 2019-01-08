ActiveAdmin.register_page "Dashboard" do

  menu priority: 0, label: proc{ I18n.t("active_admin.dashboard") }

  controller do
    def dashboard_service
      @dashboard_service ||= DashboardService.new
    end
  end

  content title: proc{ I18n.t("active_admin.dashboard") } do
    span do
      h2 "Ocupación #{l(Date.today, format: '%A %e %b %Y')}: <b>#{controller.dashboard_service.total_occupation}</b>".html_safe
    end

    render partial: 'stats_table', locals: { service: controller.dashboard_service }
  end
end

