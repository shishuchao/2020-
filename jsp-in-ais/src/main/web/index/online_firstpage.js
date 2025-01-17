/**
 * Created by xujun on 2017/2/15.
 */
var OnlineFirstPage = function(){

    return {
    	homeStatistics: function() {
    	    $.getJSON(contextPath + '/portal/simple/homeStatistics.action', {
    	        'random': Math.random(), 'homeType':'online'
    	    }, function(json) {
    	        if (json) {
    	            var d1 = json.d1;
    	            var d2 = json.d2;
    	            var d3 = json.d3;
    	            var d4 = json.d4;
    	            var d5 = json.d5;
    	            var d6 = json.d6;
    	            $('#hs_allProject').text(d1);
    	            $('#hs_inprogress').text(d2);
    	            $('#hs_prepare').text(d3);
    	            $('#hs_actualize').text(d4);
    	            $('#hs_account').text(d5);
    	            $('#hs_rework').text(d6);
    	        }
    	    });
    	},
    	msgReminderTable: function () {
            var msgReminder = $("#msgReminder");
            var maxRows = 5;
            msgReminder.empty();
            $.getJSON(contextPath+'/msg/innerMsg_list.action?readFlag=2', {'random':Math.random(),'querySource':'grid'}, function (json) {
                if (json.rows.length > 0) {
                	$('#msgTitleTip').text(json.rows.length);
                    var titleRow = '<li style="background:#e3eefd;font-weight:bold;">' +
                        '<div class="task-title row" >' +
                        '<div class="col-xs-2" style="text-align: center;width: 62%"><span class="task-title-sp" style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;display: inline-block;">' +
                        '消息标题</span></div>' +
                        '<div class="col-xs-2" style="text-align: center; width: 10%"><span class="task-title-sp" style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;display: inline-block;">' +
                        '发送人</span></div>' +
                        '<div class="col-xs-2" style="text-align: center;width: 28%"><span class="task-title-sp" style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;display: inline-block;">' +
                        '发送时间</span></div>' +
                        '</div></li>';
                    msgReminder.append(titleRow);
                    for (var index in json.rows) {
                    	if(index > maxRows) break;
                        var obj = json.rows[index];
            			var f = index % 2 == 1 ;
            			var t = obj.createTime;
            			if(t){
            				t = t.replace('T',' ');
            			}
                        var li = (f ? "<li class='datagrid-row-alt'>" : '<li>') +
                            '<div class="task-title" style="cursor: pointer;" onclick="parent.goMenu(\'消息提醒\',\''+contextPath+'/msg/innerMsg_view.action?innerMsg.msgId='+obj.msgId+'\',\'1\')">' +
                            '<span class="task-title-sp" title="'+obj.subject+'" style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;width:50%;display: inline-block;">' +
                            obj.subject +
                            '</span>' +
                            '<span class="task-title-sp" style="display: inline-block;overflow:hidden;">'+obj.fromUserName+'</span>' +
                            '<span class="task-title-sp" style="display: inline-block;overflow:hidden;float:right;width:150px;text-align:center">'+t+'</span>' +
                            '</div>' +
                            '</li>';
                        msgReminder.append(li);
                    }
                }else{
                    var titleRow = '<li style="background:#e3eefd;font-weight:bold;">' +
                        '<div class="task-title row" >' +
                        '<div class="col-xs-2" style="text-align: center;width: 62%"><span class="task-title-sp" style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;display: inline-block;">' +
                        '消息标题</span></div>' +
                        '<div class="col-xs-2" style="text-align: center; width: 10%"><span class="task-title-sp" style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;display: inline-block;">' +
                        '发送人</span></div>' +
                        '<div class="col-xs-2" style="text-align: center;width: 28%"><span class="task-title-sp" style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;display: inline-block;">' +
                        '发送时间</span></div>' +
                        '</div></li>';
                    msgReminder.append(titleRow);
                	msgReminder.append('<h3 style="text-align:center;">您没有消息</h3>');
                }
            });
        },
    	todoTaskTable: function () {
            var tBody = $("#todoTaskTable").find("tbody");
            tBody.html('');
            $.ajaxSettings.async = false;
            $.getJSON(contextPath+'/portal/simple/getPendingTask.action?type=onlineSystem', {'random':Math.random()}, function (json) {
                $('#taskTitleTip').text(json.rows.length);
                if (json.rows.length > 0) {
                    for (var index in json.rows) {
                        var obj = json.rows[index];
                        //新建一行
                        var newTr = $("<tr></tr>");
                        if(index % 2 == 1){
                        	newTr.addClass('datagrid-row-alt');
                        }
                        newTr.css('border-bottom','1px solid #e6e6e6');
                        //新建节点
                        var nameTd = $("<td class='longTD' title='"+obj.formNameDetail+"'></td>");
                        var userTd = $("<td style='color:#666'></td>");
                        var timeTd = $("<td style='color:#666'></td>");
                        //新建超链接
                        var nameA = $("<a href='javascript:;' onclick=\"parent.goMenu('待办事项处理','"+contextPath+ obj.editUrl+"&flag=yes&todoback=1&project_id="+obj.project_id+"&code="+obj.plan_code+"','1')\"></a>");

                        userTd.text(obj.fromActorName);
                        timeTd.text(obj.create);
                        nameA.text(obj.formNameDetail);
                        nameTd.append(nameA);

                        newTr.append(nameTd);
                        newTr.append(userTd);
                        newTr.append(timeTd);
                        tBody.append(newTr);
                    }
                }else{
                	tBody.append('<tr><td colspan=3><h3 style="text-align:center;">您没有要处理的事项</h3></td></tr>');
                }
            });
        },
        myProjectTable: function () {
            var tBody = $("#myProjectsTable").find("tbody");
            tBody.html('');
            $.ajaxSettings.async = false;
            $.getJSON(contextPath+'/project/listMyProjectFirstPage.action', {'random':Math.random()}, function (json) {
                if (json.rows.length > 0) {

                    for (var index in json.rows) {
                        var obj = json.rows[index];
                        //新建一行
                        var newTr = $("<tr></tr>");
                        if(index % 2 == 1){
                        	newTr.addClass('datagrid-row-alt');
                        }
                        newTr.css('border-bottom','1px solid #e6e6e6');
                        //新建节点
                        var nameTd  = $("<td style='overflow:hidden;white-space:nowrap;text-overflow:ellipsis;' class='longTD' style='color:#666' title='"+obj.projectName+"'></td>");
                        var roleTd  = $("<td style='overflow:hidden;white-space:nowrap;text-overflow:ellipsis;' class='longTD' style='color:#666' title='"+obj.roleName+"'></td>");
                        var stageTd = $("<td style='overflow:hidden;white-space:nowrap;text-overflow:ellipsis;' ></td>");
                        //新建超链接
                        var stageA='';
                        var state = obj.projectState;

                        if(state == "prepare"){
                            stageA =$("<a href=\"javascript:;\" style=\"font: bolder;\" onclick=\"openTarget2online('"+obj.projectId+"','prepare');\">准备</a>");
                        }

                        if(state == "actualize"){
                            stageA =$("<a href=\"javascript:;\" style=\"font: bolder;\" onclick=\"openTarget2online('"+obj.projectId+"','actualize');\">实施</a>&nbsp;|&nbsp;<a href=\"javascript:;\" style=\"font: bolder;\" onclick=\"openTarget2online('"+obj.projectId+"','report');\">终结</a>");
                        	//stageA =$("<a href=\"javascript:;\" style=\"font: bolder;\" onclick=\"openTarget2online('"+obj.projectId+"','prepare');\">准备</a>");
                        }

                        // if(state == "report"){
                        //     stageA =$("<a href=\"javascript:;\" style=\"font: bolder;\" onclick=\"openTarget2online('"+obj.projectId+"','report');\">终结</a>");
                        // }

                        if(state == "archives"){
                            stageA =$("<a href=\"javascript:;\" style=\"font: bolder;\" onclick=\"openTarget2online('"+obj.projectId+"','archives');\">归档</a>");
                        }

                        if(state == "rework"){
                            stageA =$("<a href=\"javascript:;\" style=\"font: bolder;\" onclick=\"openTarget2online('"+obj.projectId+"','rework');\">整改</a>");
                        }

                        nameTd.text(obj.projectName);
                        roleTd.text(obj.roleName);
                        stageTd.append(stageA);

                        newTr.append(nameTd);
                        newTr.append(roleTd);
                        newTr.append(stageTd);
                        tBody.append(newTr);
                    }
                }else{
                	tBody.append('<tr><td colspan=3><h3 style="text-align:center;">您没有要处理的项目</h3></td></tr>');
                }
            });
        },
        planPieChart:function(){
            var chart = document.getElementById('planEcharts');
            var echart = echarts.init(chart);

            echart.showLoading({
                text:'数据加载中，请稍后...'
            });
            $.ajaxSettings.async = false;

            var series = [];
            var legend = [];
            $.getJSON(contextPath+'/project/projectStatistics.action',{},function(json){
                legend = json.legend;
                series = json.series;
            });

            var options = {
                tooltip : {
                    trigger: 'item',
                    formatter: "{a} <br/>{b} : {c} ({d}%)"
                },
                legend: {
                    orient: 'horizontal',
                    data: legend
                },
                series : series,
                color:['#50acc4','#7f66a0', '#9bb95f', '#f5954f', '#5282bb','#be5150',  '#ca8622', '#bda29a','#6e7074', '#546570', '#c4ccd3']
            };

            echart.setOption(options);
            echart.hideLoading();
            window.onresize = function () {
                //重置容器高宽
                echart.resize();
            };
        }
    }
}();



function goOnline(step) {
    var winTitle = step;
    var winUrl = "about:blank";
    if(step == '全部项目'){
        winUrl = contextPath + '/portal/simple/onlineThrow.action?step=all';
    } else if(step == '正在进行中') {
        winUrl = contextPath + '/portal/simple/onlineThrow.action?step=run';
    } else if(step == '准备阶段') {
        winUrl = contextPath + '/portal/simple/onlineThrow.action?step=zb';
    } else if(step == '实施|终结阶段') {
        winUrl = contextPath + '/portal/simple/onlineThrow.action?step=ss';
    } else if(step == '归档阶段') {
        winUrl = contextPath + '/portal/simple/onlineThrow.action?step=gd';
    } else if(step == '整改阶段') {
        winUrl = contextPath + '/portal/simple/onlineThrow.action?step=zg';
    }
    window.parent.addTab('tabs',winTitle,winTitle,winUrl, true);
}

function openTarget2online(formId, stage){
    /*if(stage == 'archives'){
        window.parent.goOther(formId,stage);
        return false;
    }*/
    var udswin = window.open(
        contextPath+'/project/prepare/projectIndex.action?crudId='
        + formId + '&stage=' + stage, '',
        'height='+window.screen.availHeight+'px, width='+window.screen.availWidth+'px, fullscreen=yes, toolbar=no, menubar=no, scrollbars=no,resizable=yes,location=no, status=no');
    udswin.moveTo(0, 0);
    udswin.resizeTo(window.screen.availWidth,window.screen.availHeight);
}

$(document).ready(function(){
	/*
	try{
	    var defWidth = 220;
        if ($('body').width()<1400){
            defWidth = 195;
        }
	    else if ($('body').width()<1500){
	        defWidth = 210;
        }
		audRecomputeHomeStBar('homeStBar', 6, defWidth);
	}catch(e){
		alert(e.message);
	}*/
	try{
		
		OnlineFirstPage.todoTaskTable(); 
		$('#todoTask .portlet-title a[id="task_reload"]').click(function(e){
			e.preventDefault();
			e.stopPropagation();
			OnlineFirstPage.todoTaskTable();
		});

	}catch(e){}

	try{
		
		OnlineFirstPage.myProjectTable();
		$('#myProjects .portlet-title a[id="pro_reload"]').click(function(e){
			e.preventDefault();
			e.stopPropagation();
			OnlineFirstPage.myProjectTable();
		});
		$('#myProjects_more').click(function(e){
			e.preventDefault();
			e.stopPropagation();
			parent.addTab('tabs','我的项目','myproject',contextPath+'/project/listMyProject.action',true);
		});
	}catch(e){}
	
	try{
		OnlineFirstPage.msgReminderTable();
		OnlineFirstPage.homeStatistics();
	}catch(e){}
	
	try{
		
		$('#task_more').click(function(e){
			e.preventDefault();
			e.stopPropagation();
			var activeTabBar = $('body').data('activeTabBar');
			if(activeTabBar == 'todoTask'){
				parent.addTab('tabs','审批事项','pending',contextPath+'/bpm/taskinstance/pending4V6.action',true);
			}else{
				//parent.addTab('tabs','消息提醒','pending',contextPath+'/msg/innerMsg_list.action?readFlag=-1',true);
				parent.addTab('tabs','消息提醒','pending',contextPath+'/msg/innerMsg_listAll.action',true);
			}
		});
	}catch(e){}
	
});