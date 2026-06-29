package com.poly.manager.service;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.poly.manager.config.AppConfig;

import jakarta.servlet.http.Part;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.Map;
import java.util.UUID;

public class CloudinaryService {
    private final Cloudinary cloudinary;
    private final long maxBytes=AppConfig.getLong("upload.max_bytes",20971520);

    public CloudinaryService() {
        cloudinary=new Cloudinary(ObjectUtils.asMap(
            "cloud_name",AppConfig.get("cloudinary.cloud_name"),
            "api_key",AppConfig.get("cloudinary.api_key"),
            "api_secret",AppConfig.get("cloudinary.api_secret"),
            "secure",true));
    }

    public UploadResult upload(Part part,long groupId) throws Exception {
        if(part==null || part.getSize()==0) throw new IllegalArgumentException("File không được để trống");
        if(part.getSize()>maxBytes) throw new IllegalArgumentException("File vượt quá 20 MB");
        String fileName=fileName(part);
        String extension=extension(fileName);
        if(!"pdf,doc,docx,zip,rar,7z,txt,jpg,jpeg,png".contains(extension))
            throw new IllegalArgumentException("Định dạng file không được hỗ trợ");
        String publicId="submission-"+UUID.randomUUID().toString().replace("-","");
        Map result=cloudinary.uploader().upload(read(part),ObjectUtils.asMap(
            "resource_type","auto",
            "folder",AppConfig.get("cloudinary.folder")+"/groups/"+groupId,
            "public_id",publicId,
            "overwrite",false));
        return new UploadResult(fileName,String.valueOf(result.get("secure_url")),
            String.valueOf(result.get("public_id")),String.valueOf(result.get("resource_type")),
            ((Number)result.get("bytes")).longValue());
    }

    public void delete(String publicId,String resourceType) throws Exception {
        if(publicId==null || publicId.trim().isEmpty()) return;
        cloudinary.uploader().destroy(publicId,ObjectUtils.asMap(
            "resource_type",resourceType==null?"raw":resourceType,"invalidate",true));
    }

    private byte[] read(Part part) throws Exception {
        try(InputStream in=part.getInputStream();ByteArrayOutputStream out=new ByteArrayOutputStream()){
            byte[] buffer=new byte[8192];int read;
            while((read=in.read(buffer))!=-1) out.write(buffer,0,read);
            return out.toByteArray();
        }
    }
    private String fileName(Part part) {
        String value=part.getSubmittedFileName();
        if(value==null) return "submission";
        value=value.replace("\\","/");
        return value.substring(value.lastIndexOf('/')+1);
    }
    private String extension(String name) {
        int dot=name.lastIndexOf('.');
        return dot<0?"":name.substring(dot+1).toLowerCase();
    }
    public static class UploadResult {
        public final String fileName,url,publicId,resourceType; public final long bytes;
        public UploadResult(String fileName,String url,String publicId,String resourceType,long bytes){
            this.fileName=fileName;this.url=url;this.publicId=publicId;this.resourceType=resourceType;this.bytes=bytes;
        }
    }
}
