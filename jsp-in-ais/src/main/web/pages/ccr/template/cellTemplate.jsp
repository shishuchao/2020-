<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<%@page import="java.util.StringTokenizer"%><html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<s:include value="cellScript.jsp"></s:include>


<script type="text/javascript">
		function CreateDomDoc(){//创建XML文档对象
				var signatures = ["Msxml2.DOMDocument.5.0","Msxml2.DOMDocument.4.0","Msxml2.DOMDocument.3.0","Msxml2.DOMDocument","Microsoft.XmlDom"];
			    for(var i=0;i<signatures.length;i++) {
		           try{
		              var domDoc = new ActiveXObject(signatures[i]);
		              return domDoc;
		           }catch(e){
		           }
			    }
			    return null;
			}
		

		function CellWeb1_SaveFile(){
			
			var r=CellWeb1.UploadFile("http://<%=request.getServerName() + ":" + request.getServerPort()%>${contextPath}/ccrTemplate/saveSign.action?id=${id}");
			if(r==1){
							alert("保存成功！");
				  			//parent.location = '${contextPath}/ccrTemplate/templateList.action';
			}
			
		}
		function openSingFile(){
			var num=Math.random();
			var rnm=Math.round(num*9000000000+1000000000);//随机参数清除模态窗口缓存
			var result = CellWeb1.OpenFile("http://<%=request.getServerName() + ":" + request.getServerPort()%>${contextPath}/ccrTemplate/readSign.action?id=${id}&param="+rnm,"");
			if(result==1){
				CellWeb1.CalcManaually=true;
				CellWeb1.InputFormulaInCell=false;
				CellWeb1.SetShowFormula(1);
			}
			
		}
		function changeCellFormulaFromTree(funName){
			 CellWeb1.InputFormulaToBar(funName+"()");
			
		}
		function openFormulaWizard(){
			CellWeb1.FormulaWizard(CellWeb1.GetCurrentCol(),CellWeb1.GetCurrentRow());
		}
		
		function changeS(content){
				if(content!=""){
						CellWeb1.S(CellWeb1.GetCurrentCol(),CellWeb1.GetCurrentRow(),CellWeb1.GetCurSheet(),content);
					}
			
		}
		
		function setS(content){
			CellWeb1.S(CellWeb1.GetCurrentCol(),CellWeb1.GetCurrentRow(),CellWeb1.GetCurSheet(),content);
			CellWeb1.MoveToCell(CellWeb1.GetCurrentCol()+1,CellWeb1.GetCurrentRow());
		}
		
		
		
		function changeCellNoteFromTree(content){
			
			if(content!="")
				CellWeb1.SetCellNote(CellWeb1.GetCurrentCol(),CellWeb1.GetCurrentRow(),CellWeb1.GetCurSheet(),content);
		}
		
		function changeCellColor(){
			CellWeb1.SetCellBackColor(CellWeb1.GetCurrentCol(),CellWeb1.GetCurrentRow(),CellWeb1.GetCurSheet(),1);
		}
		function insertTheRows(){
			CellWeb1.InsertRow(2,3,0);
		}
	</script>
</head>
<body id="mainbody" class="mainBody" onload="onBodyLoaded(); "
	LANGUAGE=javascript onresize="return window_onresize(); ">
<OBJECT id=Menu1
	style="LEFT: 0px; WIDTH: 927px; TOP: -1px; HEIGHT: 19px" height=19
	width=927 classid=clsid:F82DB98D-842D-4DAB-9312-E478D8255720>
	<PARAM NAME="_Version" VALUE="65536">
	<PARAM NAME="_ExtentX" VALUE="24527">
	<PARAM NAME="_ExtentY" VALUE="503">
	<PARAM NAME="_StockProps" VALUE="0">
</OBJECT>
<s:include value="cellToolMenu.jsp"></s:include>
<div style="LEFT: 0px; POSITION: relative" >正在装载华表插件模块......</div>
<p><OBJECT id=CommonDialog1
	style="DISPLAY: none; POSITION: relative" height=32 width=32
	classid=clsid:F9043C85-F6F2-101A-A3C9-08002B2F49FB>
	<PARAM NAME="_ExtentX" VALUE="688">
	<PARAM NAME="_ExtentY" VALUE="688">
	<PARAM NAME="_Version" VALUE="393216">
	<PARAM NAME="CancelError" VALUE="1">
	<PARAM NAME="Color" VALUE="0">
	<PARAM NAME="Copies" VALUE="1">
	<PARAM NAME="DefaultExt" VALUE="">
	<PARAM NAME="DialogTitle" VALUE="">
	<PARAM NAME="FileName" VALUE="">
	<PARAM NAME="Filter" VALUE="">
	<PARAM NAME="FilterIndex" VALUE="0">
	<PARAM NAME="Flags" VALUE="0">
	<PARAM NAME="FontBold" VALUE="0">
	<PARAM NAME="FontItalic" VALUE="0">
	<PARAM NAME="FontName" VALUE="">
	<PARAM NAME="FontSize" VALUE="8">
	<PARAM NAME="FontStrikeThru" VALUE="0">
	<PARAM NAME="FontUnderLine" VALUE="0">
	<PARAM NAME="FromPage" VALUE="0">
	<PARAM NAME="HelpCommand" VALUE="0">
	<PARAM NAME="HelpContext" VALUE="0">
	<PARAM NAME="HelpFile" VALUE="">
	<PARAM NAME="HelpKey" VALUE="">
	<PARAM NAME="InitDir" VALUE="">
	<PARAM NAME="Max" VALUE="0">
	<PARAM NAME="Min" VALUE="0">
	<PARAM NAME="MaxFileSize" VALUE="260">
	<PARAM NAME="PrinterDefault" VALUE="1">
	<PARAM NAME="ToPage" VALUE="0">
	<PARAM NAME="Orientation" VALUE="1">
</OBJECT> <object classid="clsid:3F166327-8030-4881-8BD2-EA25350E574A"
	id=CellWeb1
	style="DISPLAY: block LEFT :   184px; POSITION: absolute; TOP: 190px"
	CODEBASE="<%=request.getContextPath()%>/resources/cell/cellweb.cab#Version=5,3,8,0429"
	height=183 width=367>
	<param name="_Version" value="65536">
	<param name="_ExtentX" value="2646">
	<param name="_ExtentY" value="1323">
	<param name="_StockProps" value="0">
</object></p>

</body>
</html>