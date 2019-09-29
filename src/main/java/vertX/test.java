package vertX;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;

import java.io.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

class hello
{
  public static void main(String[] args) throws IOException, TemplateException
  {
    /*
    Configuration conf=new Configuration();

    HashMap<String,Object> hashMap=new HashMap<>();
    //hashMap.put("length",3);
    ArrayList<String> strArr1=new ArrayList<>();
    strArr1.add("Mohan");
    strArr1.add("Sourav");
    strArr1.add("Bera");
    hashMap.put("answers",strArr1);

    Template template=conf.getTemplate("src/pages/page.ftl");

    Writer consoleWriter=new OutputStreamWriter(System.out);
    template.process(hashMap,consoleWriter);

    Writer fileWriter=new FileWriter(new File("src/pages/page.html"));

    template.process(hashMap,fileWriter);

     */

    System.out.println(LocalDate.now());

  }
}
