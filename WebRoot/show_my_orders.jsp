<%@page import="Delivery.user_info"%>
<%@page import="Delivery.rec_info"%>
<%@page import="Delivery.pack_info"%>
<%@page import="Delivery.order_info"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="css/order_info.css">
    <base href="<%=basePath%>">
    
    <title>查看我的下单订单</title>
    <meta name="viewport" content="width=device-width,height=device-height, user-scalable=no,initial-scale=1, minimum-scale=1, maximum-scale=1,target-densitydpi=device-dpi ">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
 
<jsp:useBean id="r" class="Delivery.rec_info"></jsp:useBean>
<jsp:useBean id="p" class="Delivery.pack_info"></jsp:useBean>
<jsp:useBean id="o" class="Delivery.order_info"></jsp:useBean>
<jsp:useBean id="u" class="Delivery.user_info"></jsp:useBean>
<jsp:useBean id="d" class="dao.DeliveryDao"></jsp:useBean> 

  <%
  
	String name;
	int user_id;
	if(session.getAttribute("name")!=null){
		name=session.getAttribute("name").toString();
	}else{
		name="null";
	}
	if(session.getAttribute("user_id")!=null){
		user_id=Integer.parseInt(session.getAttribute("user_id").toString());
	}else{
		user_id=0;
	}
	
 %>
 
 <body>
     <div class="choice-head">
        <div class="choice-head-con">
            <img src="image/tx_small.png">
            <a><%=name %>&nbsp;</a>
            <div class="name">童鞋，欢迎使用递归！</div>
        </div>
    </div>
    
   <div class="head">
        <div class="title">查看订单详情</div>
    </div>
    
<%
	ArrayList<order_info> orders=d.getAllOrdersByUserId(user_id);
	for(int i=0;i<orders.size();i++){
		o=(order_info)orders.get(i);
		p=(pack_info)d.getPac(o.getPack_info_id(), o.getUser_id()).get(0);
		r=(rec_info)d.getRec(o.getUser_id(), o.getRec_info_id()).get(0);
		//out.println(o.getDeliver_user_id());
		if(o.getDeliver_user_id()!=0){
			u=(user_info)d.getUser(o.getDeliver_user_id()).get(0);
		}else{
			u=new user_info();
			u.setName("暂时还没有人接单哦~");
			u.setPhone_num("暂时还没有人接单哦~");
		}
		
%>
		<div class="person">
        <div class="order_con">订单编号(系统生成)：<%=o.getOrder_id() %></div>
        <div class="order_con">收件人姓名：<%=r.getName() %> </div>
        <div class="order_con">接单人姓名：<%=u.getName() %> </div>
        <div class="order_con">接单人联系方式：<%=u.getPhone_num() %> </div>
        <div class="details"><a href="rec_detail_info.jsp?order_id=<%=o.getOrder_id() %>">查看订单详情</a></div>
        <div class="order_con">快递运送需时：<%=p.getRequire_time() %></div>
        <div class="order_price">￥<%=p.getBasic_price() %>+<%=p.getTip()%>(小费)=<%=p.getSum_price() %>.00 </div>
        <div class="person_status">状态：<%=o.getStatus() %> </div>
<%		
		if(o.getStatus().equals("已完成")){		
%>
		<div class="confirm-btn">
			<form action="assess.jsp" method="post">
				<input type="hidden" value=<%=o.getOrder_id() %> name="order_id">
				<input type="hidden" value=<%=o.getDeliver_user_id() %> name="deliver_user_id">
                <input type="submit" value="评价订单">
            </form>
        </div>
<%
		}else if(o.getStatus().equals("已评价")){
			
		}else if(u.getUser_id()!=0){
%>
        <div class="confirm-btn">
        	<form action="operater?method=confirmReceivePack" method="post">
        		<input type="hidden" value=<%=o.getOrder_id() %> name="order_id">
        		<input type="hidden" value=<%=o.getDeliver_user_id() %> name="deliver_user_id">
                <input type="submit" value="确认收货">
            </form>
        </div>
<%
		}
%>
    </div> 

<%
	}
%>

<center>
	<div class="footer">
        <div class="footer-Con">
            Copyright&copy;2016<a>南京晓庄学院信息工程学院</a>
            <br />
            <a>团队：14卓工班仙女三人行</a>
            <a>Version:Alpha 1.0.0</a>
        </div>
    </div>
</center>  
</body>
</html>
