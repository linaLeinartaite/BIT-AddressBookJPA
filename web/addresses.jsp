<%-- 
    Document   : addresses
    Created on : 10-Mar-2020, 18:45:47
    Author     : Lina
--%>

<%@page import="javax.persistence.EntityManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="lt.bit.data.Person"%>
<%@page import="lt.bit.data.DB"%>
<%@page import="lt.bit.data.Address"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            body {
                min-height: 100vh;
                display: flex;
                justify-content: top;
                align-items: left;  
                flex-direction: column;

                background: lightsteelblue;
                color: #333;
                font-family:  fantasy;
                font-size: 1rem;
                font-weight: 50; /**/
            }
            .btn{

                font-family:  fantasy;
                text-decoration: none;
                font-size: 20px;
                padding: 5px 25px;
                margin: 5px 0px;
                border: none;
                border-radius: 5px;
            }
            .btn-s{
                background-color: cadetblue;
                font-family:  fantasy;
                text-decoration: none;
                font-size: 15px;
                padding: 2px 5px;
                margin: 2px 2px 2px 0;
                border: none;
                border-radius: 5px;
            }
            .btn-green{
                background-color: cadetblue;
                color: black;
            }
            .btn-grey {
                background-color: lightgrey;
            }

            a{
                color:darkslateblue;
            }
            .col-1{
                display: inline-block;
                width: 50px;
            }
            .col-2{
                display: inline-block;
                width: 100px;
            }
            .col-3{
                display: inline-block;
                width: 150px;
            }
            .col-4{
                display: inline-block;
                width: 200px;
            }

        </style>
    </head>
    <body>
        <%
///!!!!!! NAUJAS 20200407 
            EntityManager em = (EntityManager) request.getAttribute("em");
            //  Connection con = (Connection) request.getAttribute("con");

//tikrinsim ar mums siuncia id:            
            String ids = request.getParameter("id");

            Integer id = null;
            Person p = null;
            if (ids != null) { //t.y. jei mes cia atejom per "keisti" linka;
                //(nes jei per "prideti nauja" linka tai musu ids==null); 
                try {

                    id = new Integer(ids);
///!!!!!! NAUJAS 20200407                     
                    p = DB.getPerson(em, id);

                    if (ids != null && p == null) { //cia jei nori redaguoti zmogu kurio nera (ne tas id); cia jei paduodi id daug didesni
                        response.sendRedirect("index.jsp");
                        return; //!!!!!!!!!!!!
                    }
                } catch (Exception ex) {
                    response.sendRedirect("index.jsp"); //jei ivede suda tai griztam i pagrindini psl;
                    return; //ci svarbu kad servlet'as nutrauktu darba;
                }

            }
        %>

        <div><h1><%=p.getFirstName() + " "%>
                <%=p.getLastName() + " Adresai:"%></h1></div><br>
                <div><div class="col-4"> <a class="btn btn-green" href="addressEdit.jsp?idP=<%=p.getId()%>">Pridėti Naują</a></div>  
                    <div class="col-3"> <a class="btn btn-grey" href="index.jsp">Grįžti atgal</a></div></div><br> 
        <hr>
        <div id="person">
            <%
                for (Address a : DB.getAddresses(em, id)) {
            %> 

            <div class="col-1">Id:<%= a.getId()%></div>
            <div class="col-4">  Adresas:  <%=a.getAddress()%> </div>             
            <div class="col-3">   Miestas:  <%=a.getCity()%> </div> 
            <div class="col-4">  Pašto kodas: <%=(a.getPostCode() != null && !a.getPostCode().equals("")) ? a.getPostCode() : " * * * * *"%> </div> 

            <div class="col-1">  <a class="btn-s" href="deleteAddress?idP=<%=p.getId()%>&idA=<%=a.getId()%>">Trinti </a> </div>            
            <div class="col-1">  <a class="btn-s" href="addressEdit.jsp?idP=<%=p.getId()%>&idA=<%=a.getId()%>"> Keisti</a> </div>            
            <hr>
            <%
                }
            %>            
        </div>
    </body>
</html>
