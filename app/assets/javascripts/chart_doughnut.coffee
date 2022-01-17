window.draw_graph_doughnut = ->
    ctx = document.getElementById("myDoughnutChart").getContext('2d')
    myDoughnutChart = new Chart(ctx, {
      type: 'doughnut',
      data: {
          labels: gon.labels,
        datasets: [
          {
            label: '1日のタスク量',
            data: gon.data,
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