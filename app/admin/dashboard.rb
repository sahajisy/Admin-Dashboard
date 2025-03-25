ActiveAdmin.register_page "Dashboard" do
  content title: "Dashboard" do
    columns do
      # First column: JLPT Levels of Applicants
      column do
        panel "JLPT Levels of Applicants" do
          # Group applicants by their JLPT level and count them
          data = Applicant.group(:jlpt_level).count
          div do
            pie_chart data, height: "400px", colors: ["#FF6384", "#36A2EB", "#FFCE56", "#4BC0C0", "#9966FF"]
          end
        end
      end

      # Second column: Admissions by Month
      column do
        panel "Admissions by Month" do
          # Group applicants by the month of their admission_date.
          # Format the month as full month name (e.g., "January").
          data = Applicant.group_by_month(:admission_date, format: "%B").count
          div do
            line_chart data, height: "400px", library: {
              title: { text: "Admissions by Month", x: -20 },
              legend: { position: 'bottom' }
            }
          end
        end
      end
    end

    render partial: 'admin/chat'
  end
end
