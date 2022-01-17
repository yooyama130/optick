window.draw_graph_line = ->
    ctx = document.getElementById("mylineChart").getContext('2d')
    myBarChart = new Chart(ctx, {
        type: 'line',
        data: {
            # labels（＝横軸になる）には指定された日付範囲を表示（例：　12月20日、12月21日・・・・）
            labels: gon.labels,
            # datasetsには、label=タスク名、data=実働時間合計（＝縦軸になる）を表示。
            # datasets: [{label: gon.data_of_tasks, data: gon.data_of_working_time} ]
            datasets: gon.datas
            borderWidth: 1
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