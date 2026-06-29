package com.poly.manager.service;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.List;
import java.util.Map;

public class PdfService {
    public byte[] groupProgress(Map<String,Object> group,List<Map<String,Object>> members,
                                List<Map<String,Object>> reports,List<Map<String,Object>> feedbacks) throws Exception {
        ByteArrayOutputStream out=new ByteArrayOutputStream();
        Document doc=new Document(PageSize.A4,40,40,50,45);
        PdfWriter.getInstance(doc,out);
        BaseFont base=BaseFont.createFont(fontPath(),BaseFont.IDENTITY_H,BaseFont.EMBEDDED);
        Font title=new Font(base,18,Font.BOLD,new Color(30,64,175));
        Font heading=new Font(base,12,Font.BOLD,new Color(30,64,175));
        Font normal=new Font(base,10);
        doc.open();
        Paragraph p=new Paragraph("BÁO CÁO TIẾN ĐỘ ĐỒ ÁN",title);p.setAlignment(Element.ALIGN_CENTER);doc.add(p);
        doc.add(new Paragraph("Nhóm: "+value(group.get("group_name")),normal));
        doc.add(new Paragraph("Đề tài: "+value(group.get("topic_title")),normal));
        doc.add(new Paragraph("Giảng viên: "+value(group.get("lecturer_name")),normal));
        doc.add(Chunk.NEWLINE);doc.add(new Paragraph("THÀNH VIÊN",heading));
        PdfPTable mt=new PdfPTable(new float[]{1,2,4,2});mt.setWidthPercentage(100);
        addHeader(mt,normal,"STT","Mã SV","Họ tên","Vai trò");
        int i=1;for(Map<String,Object> m:members)addRow(mt,normal,String.valueOf(i++),value(m.get("student_code")),value(m.get("full_name")),value(m.get("role")));
        doc.add(mt);doc.add(Chunk.NEWLINE);doc.add(new Paragraph("TIẾN ĐỘ",heading));
        for(Map<String,Object> r:reports){
            PdfPTable rt=new PdfPTable(1);rt.setWidthPercentage(100);rt.setSpacingAfter(10);
            PdfPCell h=new PdfPCell(new Phrase("Tuần "+r.get("week_number")+" - "+r.get("title"),heading));h.setBackgroundColor(new Color(219,234,254));h.setPadding(7);rt.addCell(h);
            addCell(rt,normal,"Đã hoàn thành: "+value(r.get("completed_work")));
            addCell(rt,normal,"Kế hoạch: "+value(r.get("next_plan")));
            addCell(rt,normal,"Khó khăn: "+value(r.get("difficulties")));doc.add(rt);
        }
        if(!feedbacks.isEmpty()){doc.add(new Paragraph("NHẬN XÉT",heading));for(Map<String,Object> f:feedbacks)doc.add(new Paragraph(value(f.get("lecturer_name"))+": "+value(f.get("content")),normal));}
        doc.close();return out.toByteArray();
    }
    private void addHeader(PdfPTable t,Font f,String... values){for(String v:values){PdfPCell c=new PdfPCell(new Phrase(v,f));c.setBackgroundColor(new Color(30,64,175));c.setPadding(6);t.addCell(c);}}
    private void addRow(PdfPTable t,Font f,String... values){for(String v:values){PdfPCell c=new PdfPCell(new Phrase(v,f));c.setPadding(5);t.addCell(c);}}
    private void addCell(PdfPTable t,Font f,String v){PdfPCell c=new PdfPCell(new Phrase(v,f));c.setPadding(6);t.addCell(c);}
    private String value(Object value){return value==null?"-":String.valueOf(value);}
    private String fontPath(){
        String[] paths={"/System/Library/Fonts/Supplemental/Arial.ttf","/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf","C:\\Windows\\Fonts\\arial.ttf"};
        for(String p:paths)if(new File(p).isFile())return p;
        return BaseFont.HELVETICA;
    }
}
