<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<title>风险树</title>
	<link href="${contextPath}/resources/csswin/subModal.css" rel="stylesheet" type="text/css" />
	<link href="${contextPath}/resources/css/common.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=request.getContextPath()%>/easyui/boot.js"></script>
	<script type="text/javascript" src="${contextPath}/resources/js/createOrgTree.js"></script>
	<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
	<script type="text/javascript">
		function close1(){
			$('#w').window('close');
		}
		$(function(){
			// 使用oracle特性加快加载速度，如果目标数据库不是oracle，请改为false
		    var isOracle = true;
		    var isDebug = true;
		    var taskTree = $('#auditPlanTree');
		    // 自定义 - 风险树
		    showSysTree(taskTree,{
				treeTabTitle1:"风险树",
				container:taskTree,
				cascadeCheck:false,
				dnd:true,
				noMsg:true,
				queryBox:false,
				param:{//如果使用oracle特性的话，whereHql字段必须为物理表字段，原来的templateId要写成template_Id
		        	'isOracle':isOracle,
		        	'serverCache':false,
					'rootParentId':'-1',
					'whereHql':isOracle ? "template_Id='${templateId}'" : "templateId='${templateId}'",
					'beanName':'RiskTaskTemplateTree',
					'treeId'  :'taskId',
					'treeText':'taskName',
					'treeParentId':'taskPid',
					'treeOrder':'taskCode',
					'treeAtrributes':'template_type'
				},
		        onTreeClick:function(node, treeDom){
		            try{
		                var parent = $('#auditPlanTree').tree('getParent',node.target);
		                var id = node.id;
		                var type;
		                if(node.parentId != '-1')
		                	type = node.leaf==0 ? "1":"2";
		                var taskPid = parent ? parent.id : null;
		                var path = "";
		                if(!taskPid){
		                	window.parent.frames['childBasefrm'].location.href="${contextPath}/riskManagement/knowledgeBase/riskTemplate/showContent.action?isView=${isView}&node="+node.attributes.taskId+"&path="+path+"&selectedTab=main&type="+type+"&taskPid="+taskPid+"&taskId="+id+"&templateId=<%=request.getParameter("templateId")%>";
		            	}else{
		            		window.parent.frames['childBasefrm'].location.href="${contextPath}/riskManagement/knowledgeBase/riskTemplate/showContent.action?isView=${isView}&node="+node.attributes.taskId+"&path="+path+"&selectedTab=item&type="+type+"&taskPid="+taskPid+"&taskId="+id+"&templateId=<%=request.getParameter("templateId")%>";
		            	}
		            }catch(e){
		            	 isDebug ? $.messager.alert('提示信息',"onTreeClick:"+e.message,'error') : null;
		            }
		        },
				onBeforeDrag:function(node){
					var json = $.parseJSON(node.attributes);
					if(json.template_type == '0') {
						return false;
					}
				},
				onBeforeDrop:function(target,source,point){
					var targetNode = $('#auditPlanTree').tree('getNode', target);
					var json = $.parseJSON(targetNode.attributes);
					if(json.template_type == '2'&&point=='append') {
						return false;
					}
					if(json.template_type == '0'&&point!='append') {
						return false;
					}
				},
				onDrop:function(target,source,point){
					var targetNode = $('#auditPlanTree').tree('getNode', target);
					updateTaskNode(targetNode.id,source.id,point);
				},
				onTreeContextMenu: function(e, node){
					e.preventDefault();
					var parent = $('#auditPlanTree').tree('getParent',node.target);
					if(parent.length <= 0)
						return false;

					$('#auditPlanTree').tree('select', node.target);
					$('#mm').menu('show', {
						left: e.pageX,
						top: e.pageY
					});
					var json = $.parseJSON(node.attributes);
					if(json.template_type == '2') {
						$('#mm').menu('disableItem',$('#pasteMenu'));
					}else{
						$('#mm').menu('enableItem',$('#pasteMenu'));
					}
					$('#mm').menu({
						onClick:function(item){
							if(item.id == 'copyMenu'){
								menuTaskId = node.id;
								menuTaskName = node.text;
							}else if(item.id == 'pasteMenu'){
								if(menuTaskId == null||menuTaskId == ''){
									showMessage1('请先复制事项再执行粘贴操作!');
									return;
								}
								top.$.messager.confirm('确认','确认要复制事项[<span style=\"color:red\" title="'+menuTaskName+'">'+(menuTaskName.length>20?menuTaskName.substring(0,20):menuTaskName)+'...</span>]到[<span style=\"color:red\" title="'+node.text+'">'+(node.text.length>20?node.text.substring(0,20):node.text)+'...</span>]下吗?',function(r){
									if(r){
										$.ajax({
											url:'${contextPath}/riskManagement/knowledgeBase/riskTemplate/copyTaskNode.action',
											type:'get',
											cache:false,
											data:{
												'menuTaskId':menuTaskId,
												'pasteTaskId':node.id
											},
											success:function(data){
												if(data.indexOf('ok') != -1) {
													var newNodeId = data.split("&")[1];
													reloadTree(newNodeId);
													menuTaskId = '';
													menuTaskName = '';
												}
											}
										});
									}
								});

							}
						}
					});
				}
		    });
		    
		    $('#addTaskBtn').bind('click',function(){
		    	var node = $('#auditPlanTree').tree('getSelected');
		    	if (node) {
		    		var isLeaf = $('#auditPlanTree').tree('isLeaf',node.target);
		    		if (!isLeaf) {
			    		window.parent.openWindow();
		    		} else {
		    			showMessage1('请选择审计类别进行导入!');
		    		}
		    	} else {
		    		showMessage1('请选择一条审计类别进行导入!');
		    	}
		    });
		});
		
		function expandAllTreeNodes(childrenNodes) {
			if (childrenNodes && childrenNodes.length > 0) {
				$.each(childrenNodes,function(i,children){
					if (children && !$('#auditPlanTree').tree('isLeaf',children.target)) {
						$('#auditPlanTree').tree('expand',children.target)
						try{
							var interval = window.setInterval(function(){
							var childrenNodes2 = $('#auditPlanTree').tree('getChildren',childrenNodes[i].target);
								expandAllTreeNodes(childrenNodes2);
								if (interval) {
									window.clearInterval(interval)
								}
							},10)
						}catch(e){
							expandAllTreeNodes(childrenNodes);
						}
						
					}
				});
			}
		}
		
		function getCheckNode(){
	    	var node = $('#auditPlanTree').tree('getSelected');
	    	return node;
	    }
	    
	    function reloadSelectedNode(editType,node){
	    	if (!node) {
	    		var node = $('#auditPlanTree').tree('getRoot');
	    		var selectedNode = getCheckNode();
	    		if (selectedNode && node.id != selectedNode.id) {
	    			node = $('#auditPlanTree').tree('getParent',selectedNode.target);
	    		}
	    		if (!editType){
	    			node = getCheckNode();
	    		}
	    	}
	    	$('#auditPlanTree').tree('reload',node.target);
	    }
		/**
		 * 拖拽更新方案节点
		 * @param toNodeId
		 * @param sourceNodeId
         * @param point
         */
		 function updateTaskNode(toNodeId,sourceNodeId,point){
			$.ajax({
				url:'${contextPath}/riskManagement/knowledgeBase/riskTemplate/updateTaskNode.action',
				type:'get',
				cache:false,
				data:{
					toNodeId:toNodeId,
					sourceNodeId:sourceNodeId,
					point:point
				},
				success:function(data){
					if(data == 'ok') {
						reloadTree(sourceNodeId);
					}else{
						showMessage1(data);
					}
				}
			});
		}

		/************** 公共方法 ***************/
		// 重新加载树形
		function reloadTree(nodeId){
			locationTaskTreeNode(nodeId,"");
		}

		//页面重新定位事项节点
		function locationTaskTreeNode(nodeId, text){
			try{
				$('#auditPlanTree').tree('reload');
				var timeout = window.setTimeout(function(){
					//alert('nodeId='+nodeId)
					if(nodeId){
						var url = "${contextPath}/commonPlug/getPriorNodeIdsById.action?rootParentId=-1&beanName=RiskTaskTemplateTree&treeId=taskId&treeText=taskName&treeParentId=taskPid&treeOrder=taskOrder";
						QUtil.expandPriorNodeByIds(nodeId, url, $('#auditPlanTree'), text, false);
					}
					timeout ? clearTimeout(timeout) : null;
				}, 200);
			}catch(e){
				alert("locationTaskTreeNode:\n"+e.message);
			}
		}
	</script>
</head>
<body class='easyui-layout' fit='true' border="0">
	<s:hidden id="templateId" name="templateId" value="xxx"/>
	<s:hidden id="taskId" name="taskId" />
	<%-- <s:hidden id="taskTemplateType" name="taskTemplateType" /> --%>
	<div region="center"  style='overflow:hidden;' border="0">
		<ul id="auditPlanTree"></ul>
		<div id="mm" class="easyui-menu" style="width:120px;">
			<div data-options="iconCls:'icon-edit'" id="copyMenu">复制</div>
			<div data-options="iconCls:'icon-copy'" id="pasteMenu">粘贴</div>
		</div>
	</div>
	<!-- <div region="south" style='padding:5px;overflow:hidden;text-align:right;white-space:nowrap;height:40px' border="0">
        <a href='javascript:void(0);' id='addTaskBtn' class="easyui-linkbutton"  iconCls="icon-import">导入事项</a>
    </div> --> 
</body>
</html>