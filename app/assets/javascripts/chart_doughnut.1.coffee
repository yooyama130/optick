window.draw_graph = ->
    ctx = document.getElementById("myDoughnut2Chart").getContext('2d')
    myChart = new Chart(ctx, {
      type: 'doughnut',
      data: {
          labels: gon.data_of_tasks,
        datasets: [
          {
            label: '1日のタスク量',
            data: gon.data_of_working_time_sums,
            backgroundColor: [
              'rgb(255, 99, 132)',
              'rgb(54, 162, 235)',
              'rgb(255, 205, 86)',
              'rgb(0, 193, 27)',
              'rgb(140, 0, 188)',
            ]
          }
        ]
      }
    })