﻿<!--
var cal;
var isFocus=false; //是否为焦点
//自加
var objdate

var objdate1

//选择日期
function SelectDate(obj,strFormat)
{
	//自加
	objdate = obj;
	
    var date = new Date();
    var by = date.getFullYear()-50;  //最小值 → 50 年前
    var ey = date.getFullYear()+50;  //最大值 → 50 年后
    cal = (cal==null) ? new Calendar(by, ey, 0) : cal;    //初始化英文版，0 为中文版
    cal.dateFormatStyle = strFormat;
    cal.show(obj);
}
/**//**//**//**
 * 返回日期
 * @param d the delimiter
 * @param p the pattern of your date
 * 根据用户指定的 style 来确定；
 */
//String.prototype.toDate = function(x, p) {
String.prototype.toDate = function(style) {
  var y = this.substring(style.indexOf('y'),style.lastIndexOf('y')+1);//年
  var m = this.substring(style.indexOf('M'),style.lastIndexOf('M')+1);//月
  var d = this.substring(style.indexOf('d'),style.lastIndexOf('d')+1);//日
  if(isNaN(y)) y = new Date().getFullYear();
  if(isNaN(m)) m = new Date().getMonth();
  if(isNaN(d)) d = new Date().getDate();
  var dt ;
  eval ("dt = new Date('"+ y+"', '"+(m-1)+"','"+ d +"')");
  return dt;
}

/**//**//**//**
 * 格式化日期
 * @param   d the delimiter
 * @param   p the pattern of your date
 * @author  meizz
 */
Date.prototype.format = function(style) {
  var o = {
    "M+" : this.getMonth() + 1, //month
    "d+" : this.getDate(),      //day
    "h+" : this.getHours(),     //hour
    "m+" : this.getMinutes(),   //minute
    "s+" : this.getSeconds(),   //second
    "w+" : "天一二三四五六".charAt(this.getDay()),   //week
    "q+" : Math.floor((this.getMonth() + 3) / 3),  //quarter
    "S"  : this.getMilliseconds() //millisecond
  }
  if(/(y+)/.test(style)) {
    style = style.replace(RegExp.$1,
    (this.getFullYear() + "").substr(4 - RegExp.$1.length));
  }
  for(var k in o){
    if(new RegExp("("+ k +")").test(style)){
      style = style.replace(RegExp.$1,
        RegExp.$1.length == 1 ? o[k] :
        ("00" + o[k]).substr(("" + o[k]).length));
    }
  }
  return style;
};

/**//**//**//**
 * 日历类
 * @param   beginYear 1990
 * @param   endYear   2010
 * @param   lang      0(中文)|1(英语) 可自由扩充
 * @param   dateFormatStyle  "yyyy-MM-dd";
 * @version 2006-04-01
 * @author  KimSoft (jinqinghua [at] gmail.com)
 * @update
 */
function Calendar(beginYear, endYear, lang, dateFormatStyle) {
  this.beginYear = 1990;
  this.endYear = 2010;
  this.lang = 0;            //0(中文) | 1(英文)
  this.dateFormatStyle = "yyyy-MM-dd";

  if (beginYear != null && endYear != null){
    this.beginYear = beginYear;
    this.endYear = endYear;
  }
  if (lang != null){
    this.lang = lang
  }

  if (dateFormatStyle != null){
    this.dateFormatStyle = dateFormatStyle
  }

  this.dateControl = null;
  this.panel = this.getElementById("calendarPanel");
  this.container = this.getElementById("ContainerPanel");
  this.form  = null;

  this.date = new Date();
  this.year = this.date.getFullYear();
  this.month = this.date.getMonth();


  this.colors = {
  "cur_word"      : "#FFFFFF",  //当日日期文字颜色
  "cur_bg"        : "#00FF00",  //当日日期单元格背影色
  "sel_bg"        : "#FFCCCC",  //已被选择的日期单元格背影色 2006-12-03 寒羽枫添加
  "sun_word"      : "#FF0000",  //星期天文字颜色
  "sat_word"      : "#0000FF",  //星期六文字颜色
  "td_word_light" : "#333333",  //单元格文字颜色
  "td_word_dark"  : "#CCCCCC",  //单元格文字暗色
  "td_bg_out"     : "#EFEFEF",  //单元格背影色
  "td_bg_over"    : "#FFCC00",  //单元格背影色
  "tr_word"       : "#FFFFFF",  //日历头文字颜色
  "tr_bg"         : "#666666",  //日历头背影色
  "input_border"  : "blue",  //input控件的边框颜色
  "input_bg"      : "#EEF7FF"   //input控件的背影色
  }

  this.draw();
  this.bindYear();
  this.bindMonth();
  this.changeSelect();
  this.bindData();
}

/**//**//**//**
 * 日历类属性（语言包，可自由扩展）
 */
Calendar.language = {
  "year"   : [[""], [""]],
  "months" : [["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"],
        ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"]
         ],
  "weeks"  : [["日","一","二","三","四","五","六"],
        ["SUN","MON","TUR","WED","THU","FRI","SAT"]
         ],
  "clear"  : [["清空"], ["CLS"]],
  "today"  : [["今天"], ["TODAY"]],
  "close"  : [["关闭"], ["CLOSE"]]
}

Calendar.prototype.draw = function() {
  calendar = this;

  var mvAry = [];  
  mvAry[mvAry.length]  = '  <div name="calendarForm" style="margin: 0px;">';
  mvAry[mvAry.length]  = '    <table width="100%" border="0" cellpadding="0" cellspacing="1">';
  mvAry[mvAry.length]  = '      <tr>';
  mvAry[mvAry.length]  = '        <th align="left" width="1%"><input style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:16px;height:20px;" name="prevMonth" type="button" id="prevMonth" value="&lt;" /></th>';
  mvAry[mvAry.length]  = '        <th align="center" width="98%" nowrap="nowrap"><select name="calendarYear" id="calendarYear" style="font-size:12px;"></select><select name="calendarMonth" id="calendarMonth" style="font-size:12px;"></select></th>';
  mvAry[mvAry.length]  = '        <th align="right" width="1%"><input style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:16px;height:20px;" name="nextMonth" type="button" id="nextMonth" value="&gt;" /></th>';
  mvAry[mvAry.length]  = '      </tr>';
  mvAry[mvAry.length]  = '    </table>';
  mvAry[mvAry.length]  = '    <table id="calendarTable" width="100%" style="border:0px solid #CCCCCC;background-color:#FFFFFF;font-size:9pt" border="0" cellpadding="2" cellspacing="1">';
  mvAry[mvAry.length]  = '      <tr>';
  for(var i = 0; i < 7; i++) {
    mvAry[mvAry.length]  = '      <th style="font-weight:normal;background-color:' + calendar.colors["tr_bg"] + ';color:' + calendar.colors["tr_word"] + ';">' + Calendar.language["weeks"][this.lang][i] + '</th>';
  }
  mvAry[mvAry.length]  = '      </tr>';
  for(var i = 0; i < 6;i++){
    mvAry[mvAry.length]  = '    <tr align="center">';
    for(var j = 0; j < 7; j++) {
      if (j == 0){
        mvAry[mvAry.length]  = '  <td style="cursor:default;color:' + calendar.colors["sun_word"] + ';"></td>';
      } else if(j == 6) {
        mvAry[mvAry.length]  = '  <td style="cursor:default;color:' + calendar.colors["sat_word"] + ';"></td>';
      } else {
        mvAry[mvAry.length]  = '  <td style="cursor:default;"></td>';
      }
    }
    mvAry[mvAry.length]  = '    </tr>';
  }
  mvAry[mvAry.length]  = '      <tr style="background-color:' + calendar.colors["input_bg"] + ';">';
  mvAry[mvAry.length]  = '        <th colspan="2"><input name="calendarClear" type="button" id="calendarClear" value="' + Calendar.language["clear"][this.lang] + '" style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:100%;height:18px;font-size:9pt;"/></th>';
  mvAry[mvAry.length]  = '        <th colspan="3"><input name="calendarToday" type="button" id="calendarToday" value="' + Calendar.language["today"][this.lang] + '" style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:100%;height:18px;font-size:9pt;"/></th>';
  mvAry[mvAry.length]  = '        <th colspan="2"><input name="calendarClose" type="button" id="calendarClose" value="' + Calendar.language["close"][this.lang] + '" style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:100%;height:18px;font-size:9pt;"/></th>';
  mvAry[mvAry.length]  = '      </tr>';
  mvAry[mvAry.length]  = '    </table>';  
  mvAry[mvAry.length]  = '  </div>';
  this.panel.innerHTML = mvAry.join("");
  
  /**//******** 以下代码由寒羽枫 2006-12-01 添加 **********/
  var obj = this.getElementById("prevMonth");
  obj.onclick = function () {calendar.goPrevMonth(calendar);}
  obj.onblur = function () {calendar.onblur();}
  this.prevMonth= obj;
  
  obj = this.getElementById("nextMonth");
  obj.onclick = function () {calendar.goNextMonth(calendar);}
  obj.onblur = function () {calendar.onblur();}
  this.nextMonth= obj;
  
  

  obj = this.getElementById("calendarClear");
  obj.onclick = function () {calendar.dateControl.value = "";calendar.hide();}
  this.calendarClear = obj;
  
  obj = this.getElementById("calendarClose");
  obj.onclick = function () {calendar.hide();}
  this.calendarClose = obj;
  
  obj = this.getElementById("calendarYear");
  obj.onchange = function () {calendar.update(calendar);}
  obj.onblur = function () {calendar.onblur();}
  this.calendarYear = obj;
  
  obj = this.getElementById("calendarMonth");
  with(obj)
  {
    onchange = function () {calendar.update(calendar);}
    onblur = function () {calendar.onblur();}
  }this.calendarMonth = obj;
 
  obj = this.getElementById("calendarToday");
  obj.onclick = function () {
    var today = new Date();
    calendar.date = today;
    calendar.year = today.getFullYear();
    calendar.month = today.getMonth();
    calendar.changeSelect();
    calendar.bindData();
    calendar.dateControl.value = today.format(calendar.dateFormatStyle);
    calendar.hide();
  }
  this.calendarToday = obj; 
}

//年份下拉框绑定数据
Calendar.prototype.bindYear = function() { 
  var cy = this.calendarYear;
  cy.length = 0;
  for (var i = this.beginYear; i <= this.endYear; i++){
    cy.options[cy.length] = new Option(i + Calendar.language["year"][this.lang], i);
  }
}

//月份下拉框绑定数据
Calendar.prototype.bindMonth = function() { 
  var cm = this.calendarMonth;
  cm.length = 0;
  for (var i = 0; i < 12; i++){
    cm.options[cm.length] = new Option(Calendar.language["months"][this.lang][i], i);
  }
}

//向前一月
Calendar.prototype.goPrevMonth = function(e){
  if (this.year == this.beginYear && this.month == 0){return;}
  this.month--;
  if (this.month == -1) {
    this.year--;
    this.month = 11;
  }
  this.date = new Date(this.year, this.month, 1);
  this.changeSelect();
  this.bindData();
}

//向后一月
Calendar.prototype.goNextMonth = function(e){
  if (this.year == this.endYear && this.month == 11){return;}
  this.month++;
  if (this.month == 12) {
    this.year++;
    this.month = 0;
  }
  this.date = new Date(this.year, this.month, 1);
  this.changeSelect();
  this.bindData();
}

//改变SELECT选中状态
Calendar.prototype.changeSelect = function() { 
  var cy = this.calendarYear;
  var cm = this.calendarMonth;
  for (var i= 0; i < cy.length; i++){
    if (cy.options[i].value == this.date.getFullYear()){
      cy[i].selected = true;
      break;
    }
  }
  for (var i= 0; i < cm.length; i++){
    if (cm.options[i].value == this.date.getMonth()){
      cm[i].selected = true;
      break;
    }
  }
}

//更新年、月
Calendar.prototype.update = function (e){ 
  this.year  = e.calendarYear.options[e.calendarYear.selectedIndex].value;
  this.month = e.calendarMonth.options[e.calendarMonth.selectedIndex].value;
  this.date = new Date(this.year, this.month, 1);
  this.changeSelect();
  this.bindData();
}

//绑定数据到月视图
Calendar.prototype.bindData = function () {
  var calendar = this;
  var dateArray = this.getMonthViewArray(this.date.getFullYear(), this.date.getMonth());
  var tds = this.getElementById("calendarTable").getElementsByTagName("td");
  for(var i = 0; i < tds.length; i++) {
  //tds[i].style.color = calendar.colors["td_word_light"];
  tds[i].style.backgroundColor = calendar.colors["td_bg_out"];
    tds[i].onclick = function () {return;}
    tds[i].onmouseover = function () {return;}
    tds[i].onmouseout = function () {return;}
    if (i > dateArray.length - 1) break;
    tds[i].innerHTML = dateArray[i];
    if (dateArray[i] != "&nbsp;"){
      tds[i].onclick = function () {
        if (calendar.dateControl != null){
          calendar.dateControl.value = new Date(calendar.date.getFullYear(),
                                                calendar.date.getMonth(),
                                                this.innerHTML).format(calendar.dateFormatStyle);
        }
        calendar.hide();
      }
      tds[i].onmouseover = function () {
        this.style.backgroundColor = calendar.colors["td_bg_over"];
      }
      tds[i].onmouseout = function () {
        this.style.backgroundColor = calendar.colors["td_bg_out"];
      }
      if (new Date().format(calendar.dateFormatStyle) ==
          new Date(calendar.date.getFullYear(),
                   calendar.date.getMonth(),
                   dateArray[i]).format(calendar.dateFormatStyle)) {
        //tds[i].style.color = calendar.colors["cur_word"];
        tds[i].style.backgroundColor = calendar.colors["cur_bg"];
        tds[i].onmouseover = function () {
          this.style.backgroundColor = calendar.colors["td_bg_over"];
        }
        tds[i].onmouseout = function () {
          this.style.backgroundColor = calendar.colors["cur_bg"];
        }
        //continue; //若不想当天单元格的背景被下面的覆盖，请取消注释
      }   
      
      if (calendar.dateControl != null && calendar.dateControl.value == new Date(calendar.date.getFullYear(),
                   calendar.date.getMonth(),
                   dateArray[i]).format(calendar.dateFormatStyle)) {
        tds[i].style.backgroundColor = calendar.colors["sel_bg"];
        tds[i].onmouseover = function () {
          this.style.backgroundColor = calendar.colors["td_bg_over"];
        }
        tds[i].onmouseout = function () {
          this.style.backgroundColor = calendar.colors["sel_bg"];
        }
      }
    }
  }
}

//根据年、月得到月视图数据(数组形式)
Calendar.prototype.getMonthViewArray = function (y, m) {
  var mvArray = [];
  var dayOfFirstDay = new Date(y, m, 1).getDay();
  var daysOfMonth = new Date(y, m + 1, 0).getDate();
  for (var i = 0; i < 42; i++) {
    mvArray[i] = "&nbsp;";
  }
  for (var i = 0; i < daysOfMonth; i++){
    mvArray[i + dayOfFirstDay] = i + 1;
  }
  return mvArray;
  /*
	var dateArray = new Array(42);
	var dayOfFirstDate = new Date(y, m, 1).getDay();
	var dateCountOfMonth = new Date(y, m + 1, 0).getDate();
	for (var i = 0; i < dateCountOfMonth; i++) {
		dateArray[i + dayOfFirstDate] = i + 1;
	}
	return dateArray;
  */
}

//扩展 document.getElementById(id) 多浏览器兼容性 from meizz tree source
Calendar.prototype.getElementById = function(id){
  if (typeof(id) != "string" || id == "") return null;
  if (document.getElementById) return document.getElementById(id);
  if (document.all) return document.all(id);
  try {return eval(id);} catch(e){ return null;}
}

//扩展 object.getElementsByTagName(tagName)
Calendar.prototype.getElementsByTagName = function(object, tagName){
  if (document.getElementsByTagName) return document.getElementsByTagName(tagName);
  if (document.all) return document.all.tags(tagName);
}

//取得HTML控件绝对位置
Calendar.prototype.getAbsPoint = function (e){
  var x = e.offsetLeft;
  var y = e.offsetTop;
  while(e = e.offsetParent){
    x += e.offsetLeft;
    y += e.offsetTop;
  }
  return {"x": x, "y": y};
}

//显示日历
Calendar.prototype.show = function (dateObj, popControl) {
  if (dateObj == null){
    throw new Error("arguments[0] is necessary")
  }
  this.dateControl = dateObj;
  
  this.date = (dateObj.value.length > 0) ? new Date(dateObj.value.toDate(this.dateFormatStyle)) : new Date();
  this.year = this.date.getFullYear();
  this.month = this.date.getMonth();
  this.changeSelect();
  this.bindData();
  
  if (popControl == null){
    popControl = dateObj;
  }
  var xy = this.getAbsPoint(popControl);
  this.panel.style.left = xy.x  + "px";
  this.panel.style.top = (xy.y + dateObj.offsetHeight) + "px"; 
 
  this.panel.style.display = "";
  this.container.style.display = "";
  
  dateObj.onblur = function(){calendar.onblur();}
  this.container.onmouseover = function(){isFocus=true;}
  this.container.onmouseout = function(){isFocus=false;}
}
//隐藏日历
Calendar.prototype.hide = function() {
  this.panel.style.display = "none";
  this.container.style.display = "none";
  isFocus=false;
  
  //***2007-01-25*******
 //*-自定义验控件是否为空--*/
//  try
// {
	 CheckDate(objdate);
//  }
//  catch(err)
//  {
//  }
}
function CheckDate(obj)	//日期
{
	//var t = document.getElementById('txtPeriod').value;
	var t = obj.value;
	var v = null;
	var tt = /^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/;
	var dv = obj.id;
		dv="dv_"+dv;
	var dvDate =document.getElementById(dv);
	
	if (dvDate == null)
	{
		return;
	}
	if(t!="")
	{
		if(t.search(tt)!=-1)
		{
			
			dvDate.style.display = 'none';
			v = 0;	
		}
		else
		{
			dvDate.style.display = 'block';
			v = 1;
		}
		if(DateCompare(obj.value,datenow)==true)
		{
			v = 0;
		}
		else
		{
			dvDate.style.display = 'block';
			dvDate.innerHTML = "  <font color=red>&nbsp;&nbsp;您的截止日期必须大于今天</font>";
			v = 1
		}
		
	}
	else
	{
		dvDate.style.display = 'block';
		v = 1;
	}
	return v;
}

//焦点转移时隐藏日历
Calendar.prototype.onblur = function() {
    if(!isFocus){this.hide();}
}
document.write('<div id="ContainerPanel" style="display:none"><div id="calendarPanel" style="position: absolute;display: none;z-index: 9999;');
document.write('background-color: #FFFFFF;border: 1px solid #CCCCCC;width:175px;font-size:9px;"></div>');
if(document.all)
{
document.write('<iframe style="position:absolute;z-index:2000;width:expression(this.previousSibling.offsetWidth);');
document.write('height:expression(this.previousSibling.offsetHeight);');
document.write('left:expression(this.previousSibling.offsetLeft);top:expression(this.previousSibling.offsetTop);');
document.write('display:expression(this.previousSibling.style.display);" scrolling="no" frameborder="no"></iframe>');
}
document.write('</div>');
 

//调用<input type=text onclick="SelectDate(this,'yyyy-MM-dd');">
// .net <script language="javascript" src=WebCalendar2.js type="text/javascript" charset="gb2312"></script> 
// gb2312可解决乱码
-->