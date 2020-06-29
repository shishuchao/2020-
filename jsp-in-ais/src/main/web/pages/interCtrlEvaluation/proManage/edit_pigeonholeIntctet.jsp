<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<title>项目档案归档流程</title>
	<script type="text/javascript" src="<%=request.getContextPath()%>/easyui/boot.js"></script>  
	<script type="text/javascript" src="${contextPath}/resources/js/createOrgTree.js"></script>
	<script type="text/javascript" src="${contextPath}/resources/js/jquery-fileUpload.js"></script>
	<script type="text/javascript" src="${contextPath}/scripts/ais_functions.js"></script>
	<script type='text/javascript' src='${contextPath}/scripts/dwr/DWRActionUtil.js'></script>
	<script type='text/javascript' src='${contextPath}/dwr/interface/DWRAction.js'></script>
	<script type='text/javascript' src='${contextPath}/dwr/engine.js'></script>
	<script type="text/javascript" src="${contextPath}/resources/csswin/common.js"></script>
	
	<script type="text/javascript">
	   /*
		* 显示或隐藏项目基本信息
		*/
		function triggerProjectInfoDiv(){
			var evt = window.event;
			var eventSrc = evt.target || evt.srcElement;
			var proInfoDiv = document.getElementById('proInfoDiv');
			if(proInfoDiv.style.display=='none'){
				eventSrc.innerText="隐藏项目信息";
				proInfoDiv.style.display='';
			}else{
				eventSrc.innerText="展开项目信息";
				proInfoDiv.style.display='none';
			}
		}
		function doStart(){
			document.getElementById('myform').action = "start.action";
			document.getElementById('myform').submit();
		}
	
		/*
		 *非空校验
		 */
		function isNull(){
			var archives_name = document.getElementsByName('crudObject.archives_name')[0].value;//档案名称
			var archives_code = document.getElementsByName('crudObject.archives_code')[0].value;//档案编号
			var archives_nameRequired = "<s:property value="varMap['archives_nameRequired']"  />";  //varMap['archives_nameRequired']
			var archives_codeRequired = "<s:property value="varMap['archives_codeRequired']"  />";//获得档案编号必填属性
			var archives_nameWrite = "<s:property value="varMap['archives_nameWrite']"  />";//可写
			var archives_codeWrite = "<s:property value="varMap['archives_codeWrite']"  />";//可写
			var project_id = document.getElementsByName('crudObject.project_id')[0].value;
			var buttonRemark = "true";
			
			if(archives_code==null || archives_code==""){
				alert("档案编号不能为空!");
				return false;
			}
			
			//档案名称必填校验
			if(archives_nameRequired =="true" && (archives_name == null || archives_name =="")){
				alert("请填写档案名称!");
				document.getElementsByName('crudObject.archives_name')[0].focus();
				return false;
			}
			
			//DWR校验档案名称不重复
			if((archives_nameWrite=="true" || archives_nameRequired =="true")
			          && (archives_name != null || archives_name !="")){
				DWREngine.setAsync(false);
				DWREngine.setAsync(false);DWRActionUtil.execute(
						{ namespace:'/archives/pigeonhole', action:'archivesNameIsOnly', executeResult:'false' }, 
						{'archivesName':archives_name,'project_id':project_id},
						xxx);
						function xxx(data){
						 	buttonRemark = data['buttonRemark'];
						}
						if(buttonRemark == "false"){
							alert("档案名称重复，请重新命名!");
							//document.getElementsByName('crudObject.archives_name')[0].focus();
							$('#archivesName').css('border-bottom','1px solid #cccccc').removeAttr('readonly').focus().select();
							return false;
						}
			}
			
			//档案编号必填校验
			if(archives_codeRequired =="true" && (archives_code == null || archives_code =="")){
				alert("请填写档案编号!");
				document.getElementsByName('crudObject.archives_code')[0].focus();
				return false;
			}
			
			//DWR校验档案编号不重复
			if((archives_codeWrite=="true" || archives_codeRequired =="true")
			          && (archives_code != null || archives_code !="")){
				buttonRemark = "true";
				DWREngine.setAsync(false);
				DWREngine.setAsync(false);DWRActionUtil.execute(
						{ namespace:'/archives/pigeonhole', action:'archivesCodeIsOnly', executeResult:'false' }, 
						{'archivesCode':archives_code,'project_id':project_id},
						xxx);
						function xxx(data){
						 	buttonRemark = data['buttonRemark'];
						}
						if(buttonRemark == "false"){
							alert("档案编号重复，请重新填写档案编号!");
							document.getElementsByName('crudObject.archives_code')[0].focus();
							return false;
						}
			}
			 return true;
		
		}
		/*
		 *保存流程表单
		 */
		function saveForm(){
			var bool  = isNull();//非空校验
			if(bool){
				myform.action="<s:url action="saveIntctet" includeParams="none"/>";
				myform.submit();
			}
				
		}
		
		
		/* 
		 *表单提交校验
		 */
		function isCloseTaizhang(){//台账是否关闭
		    var flag = false;
			var project_id = document.getElementsByName('crudObject.project_id')[0].value;
			DWREngine.setAsync(false);
			DWREngine.setAsync(false);DWRActionUtil.execute(
					{ namespace:'/archives/pigeonhole', action:'isCloseTaizhang', executeResult:'false' }, 
					{'project_id':project_id},
					xxx);
			function xxx(data){
			 	isClose = data['isClose'];
			 	if(isClose=='true'){
			 		flag = true;
			 	}
			}
			return flag;	
		}
		function toSubmit(act){
			 var myform = document.getElementById('myform');
			  var  bool  = isNull();//非空校验
			  if(bool){
				   var taizhang = '<s:property value="@ais.project.ProjectSysParamUtil@isXMTZEnabled()" />';
				   <s:if test="isUseBpm=='true'">
					   //有jbpm流程的才添加
					   if(document.getElementsByName('isAutoAssign')[0].value=='false'){
							var actor_name=document.getElementsByName('formInfo.toActorId_name')[0].value;
							if(actor_name==''){
								window.alert('下一步处理人不能为空！');
								return false;
							}
						}
					  <s:if test="taskInstanceId!=null&&taskInstanceId!=''">
							if(taizhang && !isCloseTaizhang){//校验台账是否完成
								alert("台账未完成请完成台账后继续归档！");
								return;
							}
					  </s:if>
				  </s:if>
				  <s:else>
				  		if(taizhang && !isCloseTaizhang){//校验台账是否完成
				  			alert("台账未完成请完成台账后继续归档！");
				  			return;
						}
				  </s:else>
				
				  var flag =  confirm('确认提交吗?');     
			      if(flag){
				        <s:if test="isUseBpm=='true'">
							myform.action="<s:url action="submit" includeParams="none"/>";
						</s:if>
						<s:else>
							myform.action="<s:url action="directSubmit" includeParams="none"/>";
						</s:else>			
			            myform.submit();
			       }else{
			        	return false;
			       }
			  }
		}
		
		/*
		 * 返回
		 */
		function backURLFun(){
			var url = '<s:property  value="backURL" />';
			window.location = url;
		}
	</script>
</head>
	<s:if test="taskInstanceId!=null&&taskInstanceId!=''">
		<body onload="end();">
	</s:if>
	<s:else>
		<body >
	</s:else>
			<%-- <div region="north" title="隐藏项目信息" data-options="split:false,collapsed:true" style="height:300px;">
				<%@include
					file="/pages/project/start/edit_start_include_readonly.jsp"%>
			</div> --%>
			
		<s:form action="saveIntctet" namespace="/intctet/proArchive" id="myform" name="myform" method="post">
			<s:if test="isUseTableName!='noUse'">
				<table cellpadding="0" cellspacing="1" border="0"
					class="ListTable" width="100%" align="center">
					<tr >
						<td colspan="4" class="EditHead"
							style="text-align: left; width: 90%;">
							<%-- <s:property escape="false"
								value="@ais.framework.util.NavigationUtil@getNavigation('/ais/archives/pigeonhole/listTobeStarted.action?isUseTableName=noUse')" />
							==&gt; --%>
						<!-- 	<a href="javascript:void(0);" onclick="hidden();">  -->
							<s:property
									value="crudObject.project_name" />
									<!--  </a> -->
						</td>
						<!-- <td class="EditHead"
							style="text-align: right; width: 10%; border-left: 0px"
							nowrap="nowrap">
							<a href="javascript:void(0);" onclick="triggerProjectInfoDiv();" title="项目信息">
								展开项目信息 </a>
						</td> -->
					</tr>
				</table>
			</s:if>
			<div id="proInfoDiv" style="display: none;">
				<%@include
					file="/pages/project/start/edit_start_include_readonly.jsp"%>
			</div>
			
				<table cellpadding=0 cellspacing=0 border=0 align="center" class="ListTable">
				<tr> 

					<td align="left" class="EditHead" style="width:10%;">项目名称</td>
					<td class="editTd" align="right" style="width:40%;">
						<%--<s:property value="crudObject.archives_name" />
						<s:hidden name="crudObject.archives_name" />
						<s:textfield name="crudObject.archives_name" 
						cssStyle="width:90%" maxlength="50" 
							readonly="!(varMap['archives_nameWrite']==null?true:varMap['archives_nameWrite'])"
							display="${varMap['archives_nameRead']}"/>--%>
							
						<input type="text" name="crudObject.archives_name" id="archivesName" readonly
							value="${crudObject.archives_name}" style='width:50%;border:0px;'
						/>	
					</td>

					<td align="left" class="EditHead" style="width:10%;">档案号</td>
					<td class="editTd" align="right" style="width:40%;">
						<s:textfield name="crudObject.archives_code" 
							maxlength="100" readonly="true" cssClass="noborder"
							display="${varMap['archives_codeRead']}" />
					</td>
				</tr>

				<tr >
					<td align="left" class="EditHead">档案类型</td>
					<td class="editTd" align="right">
						<s:property value="crudObject.archives_type_name" />
						<s:hidden name="crudObject.archives_type_name" />
						<s:hidden name="crudObject.archives_type" />
					</td>

					<td align="left" class="EditHead">档案状态</td>
					<td class="editTd" align="right">
						<s:property value="crudObject.archives_status_name" />
						<s:hidden name="crudObject.archives_status_name" />
					</td>
				</tr>

				<tr>
					<td align="left" class="EditHead">所属年度</td>
					<td class="editTd" align="right">
						<!--<s:property value="crudObject.archives_year" />
						<s:hidden name="crudObject.archives_year"/>-->
						<s:property value="crudObject.audit_start_time" />
						<s:if
							test="crudObject.audit_start_time != null && crudObject.audit_end_time != null">
					    &nbsp;至&nbsp;
					    </s:if>
						<s:property value="crudObject.audit_end_time" />
						<s:hidden name="crudObject.audit_end_time" />
						<s:hidden name="crudObject.audit_start_time" />
					</td>

					<td align="left" class="EditHead">
						<s:if test="varMap['basic_save_yearRequired']">
							<font color=red>*</font>
						</s:if>
						保管期限
					</td>
					<td class="editTd" align="right">
						<s:if
							test="varMap['basic_save_yearWrite']==null || crudObject.basic_save_year==null || crudObject.basic_save_year==''">
							<s:select name="crudObject.basic_save_year" id="basic_save_year"
								 cssClass="easyui-combobox" list="basicUtil.archivesSaveYearList" listKey="code"
								listValue="name"
								disabled="!(varMap['basic_save_yearWrite']==null?true:(varMap['basic_save_yearWrite']))"
								display="${varMap['basic_save_yearRead']}" />
						</s:if>
						<s:else>
							<s:property value="crudObject.basic_save_year" />
							<s:hidden name="crudObject.basic_save_year" />
							<s:hidden name="crudObject.basic_save_year_name" />
						</s:else>
						<!--基础数据选择 档案保存期限-->
					</td>
				</tr>

				<tr >
					<%--><td align="left" class="listtabletr1">
					    <s:if test="varMap['archives_secrecyRequired']">
						<font color=red>*</font> 
						</s:if>
						秘密等级：
					</td>
					<td class="ListTableTr22" align="right">
						<s:if test="varMap['archives_secrecyWrite']==null||crudObject.archives_secrecy_name==null||crudObject.archives_secrecy_name==''">
						<s:select name="crudObject.archives_secrecy"
							list="basicUtil.archivesGradeList" listKey="code"
							listValue="name"
							disabled="!(varMap['archives_secrecyWrite']==null?true:(varMap['archives_secrecyWrite']))"
							display="${varMap['archives_secrecyRead']}" />
						</s:if>
						<s:else>
							<s:property value="crudObject.archives_secrecy_name"/>
							<s:hidden name="crudObject.archives_secrecy"/>
							<s:hidden name="crudObject.archives_secrecy_name"/>
						</s:else>
						<!--基础数据选择 档案密级-->
					</td>--%>
					<td align="left" class="EditHead">工作组负责人</td>
					<td class="editTd">
						<s:property value="crudObject.principal" />
						<s:hidden name="crudObject.principal" />
					</td>
					<td align="left" class="EditHead">立档单位</td>
					<td class="editTd" align="right">
						<%-- <s:buttonText2 id="archives_unit_name" hiddenId="audit_dept"
							cssClass="noborder"  name="crudObject.archives_unit_name" 
							hiddenName="crudObject.archives_unit"
							doubleOnclick="showPopWin('${pageContext.request.contextPath}/pages/system/search/searchdata.jsp?url=${pageContext.request.contextPath}/systemnew/orgList.action&p_item=1&orgtype=1&paraname=crudObject.archives_unit_name&paraid=crudObject.archives_unit',600,350,'组织机构选择')"
							doubleSrc="${pageContext.request.contextPath}/resources/images/s_search.gif"
							doubleCssStyle="cursor:hand;border:0"
							readonly="!(varMap['archives_unitWrite']==null?true:varMap['archives_unitWrite'])"
							display="${varMap['audit_deptRead']}"
							doubleDisabled="!(varMap['archives_unit_buttonWrite']==null?true:varMap['archives_unit_buttonWrite'])" /> --%>
							
						<s:buttonText2 cssClass="noborder" id="crudObject.archives_unit_name" readonly="true" 
							name="crudObject.archives_unit_name" hiddenName="crudObject.archives_unit" hiddenId="crudObject.audit_dept" 
							doubleOnclick="showSysTree(this,
										{ url:'${pageContext.request.contextPath}/systemnew/orgListByAsyn.action?p_item=1&orgtype=1',
										  title:'请选择审计单位'
										})" 
							doubleSrc="${pageContext.request.contextPath}/easyui/1.4/themes/icons/search.png" 
							doubleCssStyle="cursor:pointer;border:0" maxlength="50" />
					</td>
				</tr>
				<tr>
					<td align="left" class="EditHead">归档人</td>
					<td class="editTd" align="right">
						<!--<s:textfield readonly="true"
							name="crudObject.archives_start_man_name" />-->
						<s:property value="crudObject.archives_start_man_name" />
						<s:hidden value="crudObject.archives_start_man_name" />
						<s:hidden name="crudObject.archives_start_man" />

					</td>
					<td align="left" class="EditHead">归档时间</td>
					<td class="editTd" align="left">
						项目归档结束后系统生成
						<s:property value="crudObject.archives_time" />
						<s:hidden name="crudObject.archives_time" />
					</td>
				</tr>

				<tr >
					<td align="left" class="EditHead">工作时间</td>
					<td class="editTd" align="right">
						<s:property value="crudObject.start_time" />
						<s:if
							test="crudObject.start_time != null && crudObject.end_time != null">
					    &nbsp;至&nbsp;
					    </s:if>
						<s:property value="crudObject.end_time" />
						<s:hidden name="crudObject.end_time" />
						<s:hidden name="crudObject.start_time" />
					</td>
					<td align="left" class="EditHead">秘密等级</td>
					<td class="editTd" align="right">
						<%-- <s:select  cssClass="easyui-combobox" name="crudObject.archives_secrecy"
							list="basicUtil.archivesGradeList" listKey="code"
							listValue="name" 
							disabled="!(varMap['archives_secrecyWrite']==null?true:(varMap['archives_secrecyWrite']))"
							display="${varMap['archives_secrecyRead']}" /> --%>
							
						<select id="archives_secrecy" class="easyui-combobox" name="crudObject.archives_secrecy" style="width:160px;" editable="false" data-options="panelHeight:125">
						       <option value="">&nbsp;</option>
						       <s:iterator value="basicUtil.archivesGradeList" id="entry">
							         <s:if test="${crudObject.archives_secrecy==code}">
						       			<option selected="selected" value="<s:property value="code"/>"><s:property value="name"/></option>
						       		 </s:if>
						       		 <s:else>
								        <option value="<s:property value="code"/>"><s:property value="name"/></option>
						       		 </s:else>
						       </s:iterator>
						    </select>	
						
						
						<%-- <s:if test="varMap['archives_secrecyWrite']==null||crudObject.archives_secrecy_name==null||crudObject.archives_secrecy_name==''">
						
						</s:if>
						<s:else>
							<s:property value="crudObject.archives_secrecy_name"/>
							<s:hidden name="crudObject.archives_secrecy"/>
							<s:hidden name="crudObject.archives_secrecy_name"/>
						</s:else>
						<!--基础数据选择 档案密级--> --%>
					</td>
				</tr>
				<tr >
					<td align="left" class="EditHead">被评价单位</td>
					<td class="editTd" colspan="3">
						<s:property value="crudObject.audit_object_name" />
						<s:hidden name="crudObject.audit_object_name" />
						<s:hidden name="crudObject.audit_object" />
					</td>
				</tr>
				
				<tr>
					<td align="left" class="EditHead">备注说明</td>
					<td class="editTd" colspan="3">
						<s:textarea name="crudObject.archivers_comment" cssStyle="width:100%;border:0px;"/>
						<input type="hidden" id="crudObject.archivers_comment.maxlength" value="1000"/>
					</td>
				</tr>

				<!-- <tr class="listtablehead">
					<td align="left" class="listtabletr1">
						审计报告文号：
					</td>
					<td class="ListTableTr22">
						<s:textfield name="crudObject.sendNum" maxlength="200"/>
					</td>
					<td align="left" class="listtabletr1">
						审计报告发文时间：
					</td>
					<td class="listtabletr2">
						 <s:textfield id="startProDate" name="crudObject.sendTime"
							readonly="true" cssStyle="width:90%" maxlength="15"
							title="单击选择日期" onclick="calendar()"
							theme="ufaud_simple" templateDir="/strutsTemplate"></s:textfield>
					</td>
				</tr> -->
			</table>
			<s:if test="${taskview != 'view' }">
				<div align="center">
					<jsp:include flush="true" page="/pages/bpm/list_transition.jsp" />
				</div>
			</s:if>
			<div align="right" style="width: 97%;padding:10px;">

				<s:if
					test="(taskInstanceId!=null && taskInstanceId!='') || isUseBpm == 'true'">
					<a class="easyui-linkbutton" data-options="iconCls:'icon-save'"  onclick="return saveForm()">保 存</a>&nbsp;&nbsp;
					<a class="easyui-linkbutton"  data-options="iconCls:'icon-view'" onclick="fnOpenModal('${crudObject.project_id}','${crudObject.archives_name}')">查看档案详细信息</a>&nbsp;&nbsp;

				</s:if>
				<s:if test="isUseBpm == 'false'">
					<a class="easyui-linkbutton" data-options="iconCls:'icon-save'"  onclick="return saveForm()">保 存</a>&nbsp;&nbsp;
					<a class="easyui-linkbutton"  data-options="iconCls:'icon-view'" onclick="fnOpenModal('${crudObject.project_id}','${crudObject.archives_name}')">查看档案详细信息</a>&nbsp;&nbsp;

				</s:if>
				<jsp:include flush="true" page="/pages/bpm/list_toBeStart.jsp" />
				&nbsp;&nbsp;&nbsp;
				<s:if test="${taskInstanceId!=null&&taskInstanceId>0}">
						<a class="easyui-linkbutton"  data-options="iconCls:'icon-undo'" onclick="this.style.disabled='disabled';window.location.href='${contextPath}/portal/simple/simple-firstPageAction!show.action'" >返回</a>&nbsp;&nbsp;
				</s:if>
				<s:else>
					<s:if test="backURL != null && backURL != ''">
					<a class="easyui-linkbutton"  data-options="iconCls:'icon-undo'"  onclick="backURLFun();" >返回</a>&nbsp;&nbsp;
					</s:if>
					<s:else>
					<a class="easyui-linkbutton"  data-options="iconCls:'icon-undo'" onclick="javascript:history.go(-1);">返回</a>&nbsp;&nbsp;
					</s:else>
				</s:else>
				<div id="viewFileInfo" title="查看档案详细信息" style='overflow:hidden;padding:0px;'>
					<iframe id="viewInfo" src="" frameborder="0" width="100%" height="100%"></iframe>
				</div>
			</div>
			<div align="center">
				<jsp:include flush="true"
					page="/pages/bpm/list_taskinstanceinfo.jsp" />
			</div>
			
			<!-- 隐藏字段 -->
			<s:hidden name="crudObject.project_id" />
			<s:hidden name="crudObject.project_code" />
			<s:hidden name="crudObject.project_name" />

			<s:hidden name="crudObject.plan_code" />
			<s:hidden name="crudObject.plan_id" />
			<s:hidden name="project_id" value="${projectStartObject.formId}" />

			<s:hidden name="crudObject.formId" />
			<s:hidden name="crudObject.archives_status" />
			<s:hidden name="isUseTableName" />
			<s:hidden name="crudObject.operateSystemType" />
			<s:hidden name="crudObject.pro_type" />
			<s:hidden name="crudObject.pro_type_name" />
		</s:form>
	
	</body>
	<script type="text/javascript">
	/*
	 * 查看档案文件
	 */
	function fnOpenModal(project_id,archive_name){ 
		var num=Math.random();
		var rnm=Math.round(num*9000000000+1000000000);//随机参数清除模态窗口缓存
		var url = "${contextPath}/archives/workprogram/pigeonhole/editArchivesFile.action?project_id="+project_id 
					+ "&archive_name=" + encodeURI(encodeURI(archive_name));
		//window.showModalDialog(url,window,"dialogWidth=950px;dialogHeight=600px") ;//"打开了一个新模态窗口" 
		window.location = url;
		/* $('#viewInfo').attr("src",url);
		$('#viewFileInfo').window('open'); */
		
	} 
	$(function(){
		$('#basic_save_year').combobox({
			panelHeight:75,
			editable:false
		});
		$('#basic_save_year').combobox('setValue','长期');
		$('#viewFileInfo').window({
			width:1000, 
			height:400,  
			modal:true,
			collapsible:false,
			maximizable:true,
			minimizable:false,
			closed:true
		});
	});
	
	</script>
</html>