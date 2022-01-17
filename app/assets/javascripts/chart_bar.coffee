window.draw_graph_bar = ->
    ctx = document.getElementById("myBarChart").getContext('2d')
    myBarChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: gon.labels,
            datasets: [{
                label: 'タスク集計',
                data: gon.data,
                borderWidth: 1
            }]
        },
      options: {
          scales: {
              yAxes: [{
                  ticks: {
                      beginAtZero:true
                  }
              }]
          },
          plugins: {
              colorschemes: {
                  scheme: 'brewer.Accent8'
              }
          }
      }
    });