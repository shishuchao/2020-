function html2excel(TableID,RepTitleID,RepCreateInfo,titleRows,SaveAsName){
	var test=new PageToExcel(TableID,RepTitleID,RepCreateInfo,titleRows,SaveAsName);
        		test.CreateExcel(false);
        		test.Exec();
        		test.TitleExec();
				test.SaveAs();
				//CloseExcel 关闭视图
			//	test.CloseExcel();   
}

function PageToExcel(TableID,RepTitleID,RepCreateInfo,titleRows,SaveAsName){
//this.lastRowColor=LastRowColor==""?0:LastRowColor;
this.lastRowColor=0;
var today=new Date();
this.saveAsName=(SaveAsName==""?today.getYear()+"年"+(today.getMonth()+1)+"月"+today.getDate()+"日.xls":SaveAsName);
this.tableId=TableID;
this.table=document.getElementById(this.tableId);//导出的table 对象
this.rows=this.table.rows.length;//导出的table总行数
this.colSumCols=this.table.rows(0).cells.length;//第一行总列数
this.endColSumCols = this.table.rows(this.rows -2 ).cells.length;
//this.fromrow=FirstRow;
this.fromrow=2;
this.beginCol=0; //起始列数
this.TitleRows=titleRows==""?1:titleRows;
this.cols=this.colSumCols+1;
this.oXL=null;
this.oWB=null;
this.oSheet=null;
this.repTitle=document.getElementById(RepTitleID).innerHTML;
this.createInfo=document.getElementById(RepCreateInfo).innerHTML;
//导出excel时去掉标题中的空格标记(&nbsp;)
this.createInfo = this.createInfo.replace(/&nbsp;/g, ' '); 
this.rowSpans=1; //行合并
    this.colSpans=1; //列合并
    this.colsName={0:"A",1:"B", 2:"C", 3:"D", 4:"E", 5:"F", 6:"G", 7:"H", 8:"I",9:"J", 10:"K", 11:"L", 12:"M", 13:"N", 14:"O", 15:"P", 16:"Q", 16:"R" ,18:"S", 19:"T", 20:"U", 21:"V", 22:"W", 23:"X", 24:"Y", 25:"Z"};

}
PageToExcel.prototype.DeleteExcelCols=function(NotShowColList){//数组NotShowColList
    //this.notShowColList=NotShowColList;//不显示列集合,1,2,3,1
    //删除excel中的列
   var m=0;
   for(var i=0;i<NotShowColList.length;i++){
         if(i>0){
            m++;
         }
        var temp=NotShowColList[i]- m;
        var index=this.colsName[temp];
   this.oSheet.Columns(index).Delete;//删除
   }
   m=0;
}


    
PageToExcel.prototype.CreateExcel=function(ExcelVisible)
{
   try{
   this.oXL = new ActiveXObject("Excel.Application"); //创建应该对象
   this.oXL.Visible = ExcelVisible;
   this.oWB = this.oXL .Workbooks.Add();//新建一个Excel工作簿
    this.oSheet = this.oWB.ActiveSheet;//指定要写入内容的工作表为活动工作表
   //不显示网格线
   this.oXL.ActiveWindow.DisplayGridlines=true;
   this.oSheet.name=this.repTitle;
   }catch(e){
    alert("无法启动Excel!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用"+e.description);
    CloseExcel();
   }
}

PageToExcel.prototype.CloseExcel=function()
{
    this.oXL.DisplayAlerts = false;   
            this.oXL.Quit();   
            this.oXL = null;   
            this.oWB=null;   
            this.oSheet=null; 
}

PageToExcel.prototype.ChangeElementToLabel=function (ElementObj){

   var GetText="";
   try{
   var childres=ElementObj.childNodes;
  
   }catch(e){ return GetText}
   if(childres.length<=0) return GetText;
   for(var i=0;i<childres.length;i++){
   try{if(childres[i].style.display=="none"||childres[i].type.toLowerCase()=="hidden"){continue;}}
   catch(e){}
    
     try{
      switch (childres[i].nodeName.toLowerCase()){
        case "#text" :
         GetText +=childres[i].nodeValue ;
         break;
        case "br" :
         GetText +="\n";
         break;
        case "img" :
         GetText +="";
         break;
        case "select" :
         GetText +=childres[i].options[childres[i].selectedIndex].innerText ;
         break;
        case "input" :
         if(childres[i].type.toLowerCase()=="submit"||childres[i].type.toLowerCase()=="button"){
          GetText +="";
         }else if(childres[i].type.toLowerCase()=="textarea"){
          GetText +=childres[i].innerText;
         }else{
          GetText +=childres[i].value;
         }
         break;
        default :
         GetText += this.ChangeElementToLabel(childres[i]);
         break;
      }
     
     }catch(e){}
   }
   return GetText;
}

PageToExcel.prototype.SaveAs=function (){
   //保存
   try{
	   //显示视图
    this.oXL.Visible =true;
    var three=this.saveAsName.split(".");
	var last=three[three.length-1];
	//GetSaveAsFilename 是另存为的提示框
	/*if(last==='xlsx'){
		var fname = this.oXL.Application.GetSaveAsFilename(this.saveAsName, "Excel Spreadsheets (*.xlsx), *.xlsx");
	}else{
		var fname = this.oXL.Application.GetSaveAsFilename(this.saveAsName, "Excel Spreadsheets (*.xls), *.xls");
	} */
	this.oWB.SetDisplayAlerts(false);
  /*  if(fname){ 
    this.oWB.SaveAs(fname);
     this.oXL.Visible =false;
    }*/
   }catch(e){}; 
}

PageToExcel.prototype.TitleExec=function(){
	
	this.oSheet.Cells(1,1).value = this.repTitle;
	this.oSheet.Range(this.oSheet.Cells(1,1),this.oSheet.Cells(1,this.endColSumCols)).Merge();
	this.oSheet.Cells(2,1).value = this.createInfo;
	this.oSheet.Range(this.oSheet.Cells(2,1),this.oSheet.Cells(2,this.endColSumCols)).Merge();
}

PageToExcel.prototype.Exec=function()
{
  
   //寻找列数，考虑到第一行可能存在
   for (var i=0; i<this.colSumCols;i++) {
    var tmpcolspan = this.table.rows(0).cells(i).colSpan;
    if ( tmpcolspan>1 ) {
     this.cols += tmpcolspan-1;
    }
   }
  
   //定义2维容器数据，1：行；2：列；值（0 可以填充，1 已被填充）
   var container=new Array(this.rows);
   for (var i=0;i<this.rows;i++) {
    container[i]=new Array(this.cols);
    for (j=0;j<this.cols;j++) {
     container[i][j]=0;
    }
   }
  
   //将所有单元置为文本，避免非数字列被自动变成科学计数法和丢失前缀的0
   this.oSheet.Range(this.oSheet.Cells(this.fromrow+1,1), this.oSheet.Cells(this.fromrow+this.rows,this.cols)).NumberFormat = "@";
   this.oSheet.Range(this.oSheet.Cells(this.fromrow+1,1), this.oSheet.Cells(this.fromrow+this.rows,this.cols)).Borders.Weight = 2;
   
   //标题行格式
   this.oSheet.Range(this.oSheet.Cells(this.fromrow+1,1), this.oSheet.Cells(this.fromrow+this.TitleRows,this.cols-1)).HorizontalAlignment = -4108; //居中
   //this.oSheet.Range(this.oSheet.Cells(this.fromrow+1,1), this.oSheet.Cells(this.fromrow+this.TitleRows,this.cols-1)).Interior.ColorIndex = 15;//http://www.msckobe.com/perltk/color_index1.htm
   //this.oSheet.Range(this.oSheet.Cells(this.fromrow+1,1), this.oSheet.Cells(this.fromrow+this.TitleRows,this.cols-1)).Font.Name = "黑体";
   this.oSheet.Range(this.oSheet.Cells(this.fromrow+1,1), this.oSheet.Cells(this.fromrow+this.TitleRows,this.cols-1)).Font.Size = 10;
   // 循环行
   for (i=0;i<this.rows;i++){
    //循环列
    for (j=0;j<this.cols;j++){
     //寻找开始列
     for (k=j;k<this.cols;k++){
      if (container[i][k]==0) {
       this.beginCol=k;
       k=this.cols; //退出循环
      }
     }
//try{
      //赋值
      //此处相应跟改 根据 标签的类型，替换相关参数
      this.oSheet.Cells(i+1+this.fromrow,this.beginCol+1).value = this.ChangeElementToLabel(this.table.rows(i).cells(j));
      
    
      //计算合并列
      try{
     this.colSpans = this.table.rows(i).cells(j).colSpan;
      }catch(e){
     this.colSpans=0   
     }
     if (this.colSpans>1) {
      //合并
      this.oSheet.Range(this.oSheet.Cells(i+1+this.fromrow,this.beginCol+1),this.oSheet.Cells(i+1+this.fromrow,this.beginCol+this.colSpans)).Merge();
     }
     //将当前table位置填写到对应的容器中
     for (k=0; k<this.colSpans;k++) {
      container[i][this.beginCol+k]= 1;
     }
     // 计算合并行
    
     try{
      this.rowSpans = this.table.rows(i).cells(j).rowSpan;
       }catch(e){
       this.rowSpans = 0;
     }
    
     if (this.rowSpans>1) { //行合并
      this.oSheet.Range(this.oSheet.Cells(i+1+this.fromrow,this.beginCol+1),this.oSheet.Cells(i+this.rowSpans+this.fromrow,this.beginCol+this.colSpans)).Merge();
      //将当前table位置填写到对应的容器中
      for (k=1; k<this.rowSpans;k++) { //由于第0行已经被colSpans对应的代码填充了，故这里从第1行开始
       for (l=0;l<this.colSpans;l++) {
        container[i+k][this.beginCol+l]=1;
       }
      }
     }
     //如果开始列＋合并列已经等于列数了，故不需要再循环html table
     if (this.beginCol+this.colSpans>=this.cols) j=this.cols;
   
    }
    if(i==0)
    {
     //标题栏
     this.oSheet.Range(this.oSheet.Cells(1,1), this.oSheet.Cells(1,1)).Font.Size=20; 
     this.oSheet.Range(this.oSheet.Cells(1,1), this.oSheet.Cells(1,1)).Font.Bold = true; 
     this.oSheet.Range(this.oSheet.Cells(1,1), this.oSheet.Cells(1,1)).HorizontalAlignment = -4108; //居中
     this.oSheet.Range(this.oSheet.Cells(1,1), this.oSheet.Cells(1,1)).Rows.RowHeight = 40;
    }
    
     //自动调整行高
   }
  
  
   //最后一行是否空色
   try{
    this.oSheet.Range(this.oSheet.Cells(this.rows,1), this.oSheet.Cells(this.rows,1)).Font.Color=this.lastRowColor;
   }catch(e){}

   this.oSheet.Range(this.oSheet.Cells(this.fromrow+2,1), this.oSheet.Cells(this.fromrow+this.rows,this.cols)).Rows.RowHeight=20; 
   this.oSheet.Range(this.oSheet.Cells(this.fromrow+2,1), this.oSheet.Cells(this.fromrow+this.rows,this.cols)).Font.Size=10;
   //自动换行
   this.oSheet.Range(this.oSheet.Cells(this.fromrow+2,1), this.oSheet.Cells(this.fromrow+this.rows,this.cols)).WrapText = true;
   //自动调整列宽
   this.oSheet.Range(this.oSheet.Cells(this.fromrow+1,1), this.oSheet.Cells(this.fromrow+this.rows,this.cols)).Columns.AutoFit();
   //点虚线
  // this.oSheet.Range(this.oSheet.Cells(this.fromrow+1,1), this.oSheet.Cells(this.fromrow+this.rows,this.cols-1)).Borders.LineStyle = -4118;
  

    

   return this.rows;
}