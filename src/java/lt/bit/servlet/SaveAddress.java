package lt.bit.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import javax.persistence.EntityManager;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import lt.bit.data.Address;
import lt.bit.data.DB;
import lt.bit.data.Person;

/**
 *
 * @author Lina
 */
@WebServlet(name = "SaveAddress", urlPatterns = {"/saveAddress"})
public class SaveAddress extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        EntityManager em = (EntityManager) request.getAttribute("em");

        String idPs = request.getParameter("idP");
        String idAs = request.getParameter("idA");
        Integer idA = null;
        Person p = null;
        Address an = null;

        if (idPs != null) {
            try {
                p = DB.getPerson(em, new Integer(idPs));
                if (p == null) {
                    response.sendRedirect("addresses.jsp?id=" + idPs);
                    return;
                }

            } catch (Exception ex) {
                response.sendRedirect("addresses.jsp?id=" + idPs);
                return;
            }
            an = new Address();
            if (request.getParameter("ad").trim().equals("") || request.getParameter("m").trim().equals("")) {
                response.sendRedirect("addresses.jsp?id=" + idPs);
                return;
            }
            an.setAddress(request.getParameter("ad"));
            an.setCity(request.getParameter("m"));

            if (request.getParameter("pk").trim().equals("")) {
                an.setPostCode(null);
            } else {
                an.setPostCode(request.getParameter("pk"));
            }
            if (idPs != null && idAs != null) {
                idA = new Integer(idAs);
                an.setId(idA);

                for (Address a : DB.getAddresses(em, p.getId())) {
                    if (idA.equals(a.getId())) {
                        DB.updateAddress(em, an);
                    }
                }
            } else {
                DB.addAddress(em, p.getId(), an);
            }

        }

        response.sendRedirect("addresses.jsp?id=" + idPs); 
        return;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
