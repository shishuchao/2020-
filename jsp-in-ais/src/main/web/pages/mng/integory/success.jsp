<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		
		<title>系统提示</title>
	</head>
	<body >
	
	<script type="text/javascript">
		function init(){
			//var url = window.parent.dialogArguments.location.href;
			alert("提交成功！");
		   // window.parent.parent.location.href = "/ais/project/integory/searchIntegory.action";
			//alert(window.document.title);
			//alert(window.parent.document.title);
			window.parent.close();
		}
		init();
	</script>
	
		<table width="100%" height="100%">
			<tr>
				<td align="center">
					<font size="4" color='#1b6252'>操作完成</font>
				</td>
			</tr>
		</table>
	</body>
</html>