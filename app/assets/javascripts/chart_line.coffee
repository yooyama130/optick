window.draw_graph_line = ->
    ctx = document.getElementById("mylineChart").getContext('2d')
    myBarChart = new Chart(ctx, {
        type: 'line',
        data: {
            # labels（＝横軸になる）には指定された日付範囲を表示（例：　12月20日、12月21日・・・・）
            labels: gon.labels,
            # datasetsには、label=タスク名、data=実働時間合計（＝縦軸になる）を表示。
            # datasets: [{label: gon.data_of_tasks, data: gon.data_of_working_time} ]
            datasets: gon.datas,
            backgroundColor: [
                'rgba(255, 99, 132, 0.2)',
                'rgba(54, 162, 235, 0.2)',
                'rgba(255, 206, 86, 0.2)',
                'rgba(75, 192, 192, 0.2)',
                'rgba(153, 102, 255, 0.2)',
                'rgba(255, 159, 64, 0.2)'
            ],
            borderColor: [
                'rgba(255,99,132,1)',
                'rgba(54, 162, 235, 1)',
                'rgba(255, 206, 86, 1)',
                'rgba(75, 192, 192, 1)',
                'rgba(153, 102, 255, 1)',
                'rgba(255, 159, 64, 1)'
            ],
            borderWidth: 1
        },
        options: {
            scales: {
                yAxes: [{
                    ticks: {
                        beginAtZero:true
                    }
                }]
            }
        }
    })