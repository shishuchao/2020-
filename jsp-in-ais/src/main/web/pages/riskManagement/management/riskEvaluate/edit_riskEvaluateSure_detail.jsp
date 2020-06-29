<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<jsp:directive.page import="ais.framework.util.UUID"/>

<html>
<title>风险评估结果确认审核--风险评估详情--确认审核页面</title>
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8"> 
	<link href="<%=request.getContextPath()%>/resources/csswin/subModal.css" rel="stylesheet" type="text/css" />
	<link href="<%=request.getContextPath()%>/resources/css/common.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=request.getContextPath()%>/easyui/boot.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/createOrgTree.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/easyui/contextmenu.js"></script>  
	<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/common.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/pages/tlInteractive/tlInteractiveCommon.js"></script> 
	
	<script type="text/javascript">
		$(function(){
			$('#tt').tabs({
				onSelect:function(title,index){
					if(title == '影响程度评估') {
						if($('#iframe02').attr('src') == ''){
							$('#iframe02').attr('src','${contextPath}/riskManagement/management/riskEvaluate/listInfluenceSDs.action?rrs_id=${rrs_id}&riskWaitId=${riskWaitId}');
						}
					}
					else if(title == '评估结果') {
						if($('#iframe03').attr('src') == ''){
							$('#iframe03').attr('src','${contextPath}/riskManagement/management/riskEvaluate/listRiskGrades.action?rrs_id=${rrs_id}&riskWaitId=${riskWaitId}');
						}
					}
				} 
			});
		});
	</script>

</head>
<body>
    <div id="tt" class="easyui-tabs" fit="true" border="0" style="overflow: hidden">
    	<div title="可能性评估" style="overflow:hidden;padding:10px;">
    		<iframe id="iframe01" src="${contextPath}/riskManagement/management/riskEvaluate/listProbabilitySDs.action?rrs_id=${rrs_id}&&riskWaitId=${riskWaitId}" 
    		width="100%" height="100%" frameBorder="0"></iframe>
    	</div>
    	<div title="影响程度评估" style="overflow:hidden;padding:10px;">
    		<iframe id="iframe02" width="100%" height="100%" frameBorder="0" src=""></iframe>
    	</div>
    	<div title="评估结果" style="overflow:hidden;padding:10px;">
    		<iframe id="iframe03" width="100%" height="100%" frameBorder="0" src=""></iframe>
    	</div>
    </div>
</body>
</html>
