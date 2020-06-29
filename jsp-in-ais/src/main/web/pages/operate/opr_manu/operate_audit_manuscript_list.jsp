<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>审计底稿查询列表</title>
		<link href="${contextPath}/resources/css/common.css" rel="stylesheet" type="text/css" />
     	<script type="text/javascript" src="<%=request.getContextPath()%>/easyui/boot.js"></script>   
		<script type="text/javascript" src="<%=request.getContextPath()%>/easyui/contextmenu.js"></script>   
		<script type="text/javascript" src="${contextPath}/resources/js/createOrgTree.js"></script>
		<script type="text/javascript" src="${contextPath}/scripts/ais_functions.js"></script>
		<script type='text/javascript' src='${contextPath}/scripts/dwr/DWRActionUtil.js'></script>
		<script type='text/javascript' src='${contextPath}/dwr/interface/DWRAction.js'></script>
		<script type='text/javascript' src='${contextPath}/dwr/engine.js'></script>
		<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
	</head>
	<body style="margin: 0;padding: 0;overflow:hidden;" class="easyui-layout">
	<div id="list_decide_seac" class="searchWindow">
		<div class="search_head">
		<s:form name="myform"  id ="myform" action="listAuditManuscript" namespace="/operate/manuExt" method="post">
			<table id="searchTable" cellpadding=0 cellspacing=0 border=0 align="center" class="ListTable">
				<tr>
					<td class="EditHead" style="width:15%">项目名称</td>
					<td class="editTd" style="width:35%">
						<s:textfield cssClass="noborder" name="projectStartObject.project_name" maxlength="50" cssStyle="width:80%"/>
					</td>
					<td class="EditHead">审计单位</td>
					<td class="editTd">
						<s:buttonText2 name="projectStartObject.audit_dept_name" cssClass="noborder" cssStyle="width:80%"
							hiddenName="projectStartObject.audit_dept"
							doubleOnclick="showSysTree(this,
								{ url:'${pageContext.request.contextPath}/systemnew/orgListByAsyn.action',
								  title:'请选择审计单位',
                                  param:{
                                    'p_item':1,
                                    'orgtype':1
                                  }
								})"
							doubleSrc="${pageContext.request.contextPath}/resources/images/s_search.gif"
							doubleCssStyle="cursor:hand;border:0" readonly="true" />
					</td>
				</tr>
					<tr>
					<td class="EditHead">项目类别</td>
							<td class="editTd">
							    <s:buttonText name="projectStartObject.pro_type_name" cssClass="noborder"
										hiddenName="projectStartObject.pro_type" cssStyle="width:80%"
										doubleOnclick="getItem('/pages/basic/code_name_tree_select.jsp','&nbsp;请选择项目类别',500,400)"
										doubleSrc="/resources/images/s_search.gif"
										doubleCssStyle="cursor:hand;border:0" readonly="true"
										doubleDisabled="false" />
								<input type="hidden" name="projectStartObject.pro_type_child" value=""/>
		
							</td>
							
							<td class="EditHead">
								项目年度
							</td>
							<td class="editTd">
								    <select editable="false" id="w_plan_year" class="easyui-combobox" name="projectStartObject.pro_year" style="width:80%" >
								       <option value="">请选择</option>
								       <s:iterator value="@ais.project.ProjectUtil@getIncrementSearchYearList(10,9)" id="entry">
								         <option value="<s:property value="key"/>"><s:property value="value"/></option>
								       </s:iterator>
								    </select>	 
							</td>
					</tr>
			</table>
			<s:hidden id="crudIdStrings" name="crudIdStrings"/>
		</s:form>
		</div>
		<div class="serch_foot">
	        <div class="search_btn">
				<a class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearch()">查询</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="restal()">重置</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#list_decide_seac').window('close')">取消</a>
			</div>
		</div>
	</div>
	
	
	
	 <div region="center">
		 <table id="list"></table>
	</div> 
	
	
	<div id="subwindow" class="easyui-window" title="" iconCls="icon-search" style="width:500px;height:500px;padding:5px;" closed="true">
			<div class="easyui-layout" fit="true">
				<div region="center" border="false" style="padding:10px;background:#fff;border:1px solid #ccc;">
					<iframe id="item_ifr" name="item_ifr" src="" frameborder="0" width="100%" height="100%" scrolling="auto" ></iframe>
				</div>
				<div region="south" border="false" style="text-align:right;padding:5px 0;">
				    <div style="display: inline;" align="right">
						<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="saveF()">确定</a>
						<a class="easyui-linkbutton" iconCls="icon-remove" href="javascript:void(0)" onclick="cleanF()">清空</a>
						<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="closeWin()">关闭</a>
				    </div>
				</div>
			</div>
	</div>

	    <script type="text/javascript">
	    	//查询
			showWin('list_decide_seac');
	    	var bodyW = $('body').width();
	    	$(function(){
				$('#list').datagrid({
					url : "<%=request.getContextPath()%>/operate/manuExt/listAuditManuscript.action?querySource=grid",
					method:'post',
					showFooter:true, //脚本
					rownumbers:true, //行号
					pagination:true, //分页
					striped:true,
					autoRowHeight:false,
					fit:true,
					idField:'crudIds',	
					border:false,
					singleSelect:true,
					pageSize: 20,
					remoteSort: false,
					toolbar:[{
								id:'searchObj',
								text:'查询',
								iconCls:'icon-search',
								handler:function(){
									searchWindShow('list_decide_seac');
								}
					}],
					frozenColumns:[[		
					       			{field:'ms_code',title:'底稿编号',width:bodyW * 0.13 + 'px',sortable:true,halign:'center',align:'left',
					       				
					       			},
                                    {field:'ms_name',title:'底稿名称',width:bodyW * 0.13 + 'px',sortable:true,halign:'center',align:'left',
					       				
					       			}
						]],
					columns:[[  
						{field:'audit_dept_name',
								title:'审计单位',
								width:bodyW * 0.08 + 'px',
								halign:'center',
								align:'left',
								sortable:true
						},
						{field:'ms_status',
							title:'底稿状态',
							sortable:true, 
							width:bodyW * 0.08 + 'px',
							halign:'center',
							align:'left',
							sortable:true,
							//底稿状态,010:底稿草稿,040:正在复核,050:复核完毕,020:正在征求,030:等待复核,060:已经注销
							formatter:function(value,rowData,rowIndex){
								if(rowData.ms_status == '010'){
									return '底稿草稿';
								}
								else if(rowData.ms_status == '020'){
									return '正在征求';
								}
								else if(rowData.ms_status == '030'){
									return '等待复核';
								}
								else if(rowData.ms_status == '040'){
									return '正在复核';
								}
								else if(rowData.ms_status == '050'){
									return '复核完毕';
								}
								else return '已经注销';
							}
						},		
						{field:'task_name',
							 title:'审计事项',
							 width:bodyW * 0.08 + 'px',
							 halign:'center',
							 align:'left',
							 sortable:true
						},
						{field:'audit_object_name',
							 title:'被审计单位',
							 width:bodyW * 0.08 + 'px',
							 halign:'center', 
							 align:'left', 
							 sortable:true
							 },
						{field:'audit_found',title:'关联疑点',halign:'center',width:100,sortable:true,align:'left',
				       				formatter:function(value,row,rowIndex){
				       						var audit_found = row.audit_found;
				       						if(null!=audit_found){
				       							var manuId = audit_found.split(',');
				       							return manuId[1];
				       						}else{
				       							return "";
				       						}
									}},
						{field:'ms_owner',
							 title:'底稿所属人',
							 width:bodyW * 0.08 + 'px',
							 halign:'center',
							 align:'left',
							 sortable:true
							 },
						{field:'ms_author_name',
							 title:'底稿录入人',
							 width:bodyW * 0.08 + 'px',
							 halign:'center', 
							 align:'left', 
							 sortable:true
							 },
						{field:'linkManuName',
							 title:'引用底稿',
							 width:bodyW * 0.08 + 'px',
							 halign:'center', 
							 align:'left', 
							 sortable:true
							 },	 
						{field:'prom',
							 title:'问题',
							 width:bodyW * 0.08 + 'px',
							 halign:'center',
							 align:'center',
							 sortable:true
							 },
							 {field:'fileCount',
									title:'附件',
									width: 40,
									halign: 'center',
									align:'right', 
									sortable:true,
									formatter:function(value,row,rowIndex){
										return row.fileCount;
								}},
						{field:'ms_date',
							 title:'创建时间',
							 width:bodyW * 0.08 + 'px',
							 halign:'center', 
							 align:'center',
							 sortable:true
							 },
						{field:'subms_date',
							 title:'最后修改时间',
							 width:bodyW * 0.08 + 'px',
							 halign:'center', 
							 align:'center',
							 sortable:true
							 },
						{field:'isSureUpload',
							 title:'是否上传签字底稿',
							 width:bodyW * 0.08 + 'px',
							 halign:'center', 
							 align:'center',
							 sortable:true,
							 formatter:function(value,row,rowIndex){
			       					if(value == '1'){
			       						return "已上传";
			       					}else{
			       						return "未上传";
			       					}
							 }
						}
					]] 
				});

				$('#list').datagrid('doCellTip', {
					onlyShowInterrupt:true,
					position : 'bottom',
					maxWidth : '200px',
					tipStyler : {
						'backgroundColor' : '#EFF5FF',
						borderColor : '#95B8E7',
						boxShadow : '1px 1px 3px #292929'
					}

				});
				});
			  function doSearch(){
		        	$('#list').datagrid({
		    			queryParams:form2Json('myform')
		    		});
		        	$('#list_decide_seac').dialog('close');
	       	 }
			   function restal(){
					resetForm('myform');
			   }
			   
			   
			   function getItem(url,title,width,height){
					$('#item_ifr').attr('src',url);
					$('#subwindow').window({
						title: title,
						width: width,
						height:height,
						modal: true,
						shadow: true,
						closed: false,
						collapsible:false,
						maximizable:false,
						minimizable:false
					});
				}
				function saveF(){
					var ayy = $('#item_ifr')[0].contentWindow.saveF();
					var ay = ayy[0].split(',');
					if(ay.length == 1){
						document.all('projectStartObject.pro_type').value=ayy[0];
					}else if(ay.length == 2){
						document.all('projectStartObject.pro_type_child').value=ay[0];
						document.all('projectStartObject.pro_type').value=ay[1];
					}
		    		document.all('projectStartObject.pro_type_name').value=ayy[1];
		    		closeWin();
				}
				function cleanF(){
					document.all('projectStartObject.pro_type').value='';
					document.all('projectStartObject.pro_type_name').value='';
		    		document.all('projectStartObject.pro_type_child').value='';
		    		closeWin();
				}
				function closeWin(){
					$('#subwindow').window('close');
				} 
					
			    </script>
			     <script type="text/javascript">
					// 初始化
					$(function(){
						$('#lrsjyd_div').window({
							width:500,   
							height:250,   
							modal:true,
							collapsible:false,
							maximizable:false,
							minimizable:false,
							closed:true
						});
						// 打开录入窗口时，清空录入框
						$('#assign_tracker').bind('click',function(){
							if(assignTracker()){
								$('#lrsjyd_div').window('open');
								clearTrackerDiv();
							}
						});
						// 关闭录入窗口
						$('#closeWinSjyd').bind('click',function(){
							$('#lrsjyd_div').window('close');
						});
						$('#closer_div').window({   
							width:500,   
							height:250,   
							modal:true,
							collapsible:false,
							maximizable:false,
							minimizable:false,
							closed:true
						});
						// 打开录入窗口时，清空录入框
						$('#assign_closer').bind('click',function(){
							if(assignTracker()){
								$('#closer_div').window('open');
								clearCloserDiv();
							}
						});
						// 关闭录入窗口
						$('#closeWinCloser').bind('click',function(){
							$('#closer_div').window('close');
						});
						$('#saveCloser').bind('click',function(){
							var crudIdStrings = $('#crudIdStrings').val();
							$.ajax({
								dataType:'json',
								url : "${contextPath}/proledger/problem/saveCloser.action?crudIdStrings="+crudIdStrings,
								data: $('#closer_form').serialize(),
								type: "POST",
								success: function(data){
									$.messager.alert('提示信息','保存成功！','info');
								},
								error:function(data){
									$.messager.alert('提示信息','请求失败！','error');
								}
							});
						});
					});
					/*
					*  打开或关闭查询面板
					*/
					function triggerSearchTable(){
						var isDisplay = document.getElementById('searchTable').style.display;
						if(isDisplay==''){
							document.getElementById('searchTable').style.display='none';
						}else{
							document.getElementById('searchTable').style.display='';
						}
					}
					function assignTracker(){
						if($("input[name='crudIds']:checkbox:checked").length>0){
						      var crudIdStrings = '';
						      $("input[name='crudIds']:checkbox:checked").each(function(){
						      		crudIdStrings += $(this).val()+',';
						      })
						      $('#crudIdStrings').val(crudIdStrings);
						      return true;
						}else{
						      alert('没有选择审计问题');
						      return false;
						}
					}
					function cleanForm(){
						document.getElementsByName("projectStartObject.project_name")[0].value = "";
						document.getElementsByName("projectStartObject.audit_dept_name")[0].value = "";
						document.getElementsByName("projectStartObject.pro_type_name")[0].value = "";
						document.getElementsByName("projectStartObject.pro_year")[0].value = "";
					/* 	document.getElementsByName("middleLedgerProblem.audit_dept_name")[0].value = "";
						document.getElementsByName("middleLedgerProblem.audit_dept")[0].value = "";
						document.getElementsByName("middleLedgerProblem.problem_name")[0].value = "";
						document.getElementsByName("middleLedgerProblem.problem_code")[0].value = ""; */
					}
					function openMsg(projectid){
						  var viewUrl = "${contextPath}/proledger/problem/viewPro.action?crudId="+projectid;
			                $('#showPlanName').attr("src",viewUrl);
			                $('#planName').window('open');
					}
					$('#planName').window({
		                width:950, 
		                height:450,  
		                modal:true,
		                collapsible:false,
		                maximizable:true,
		                minimizable:false,
		                closed:true    
		            });
					
					function openViewMiddle(id){
						  var openViewUrl = "${contextPath}/proledger/problem/viewMiddle.action?id="+id;
			                $('#openViewMiddle').attr("src",openViewUrl);
			                $('#viewMiddle').window('open');
					}
					$('#viewMiddle').window({
		                width:950, 
		                height:450,  
		                modal:true,
		                collapsible:false,
		                maximizable:true,
		                minimizable:false,
		                closed:true    
		            });
					function openTrackList(id){
						var openViewUrl = "${contextPath}/proledger/problem/trackList.action?crudIdStrings="+id+"&onlyView=true";
			            $('#openTrackList').attr("src",openViewUrl);
			            $('#trackList').window('open');
					}
					$('#trackList').window({
		              width:950, 
		              height:450,  
		              modal:true,
		              collapsible:false,
		              maximizable:true,
		              minimizable:false,
		              closed:true    
		          });
				</script>		
			</body>
		</html>

			   
				
	  