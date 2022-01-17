window.draw_graph_doughnut = ->
    ctx = document.getElementById("myDoughnutChart").getContext('2d')
    myDoughnutChart = new Chart(ctx, {
      type: 'doughnut',
      data: {
          labels: gon.data_of_tasks,
        datasets: [
          {
            label: '1日のタスク量',
            data: gon.data_of_working_time_sums,
          }
        ]
      },
      options: {
          plugins: {
              colorschemes: {
                  scheme: 'brewer.Accent8'
              }
          }
      };
    });