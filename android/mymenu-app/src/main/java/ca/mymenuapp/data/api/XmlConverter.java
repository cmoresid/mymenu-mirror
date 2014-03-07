/*
 * Copyright (C) 2014 MyMenu, Inc.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see [http://www.gnu.org/licenses/].
 */

package ca.mymenuapp.data.api;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.lang.reflect.Type;
import org.simpleframework.xml.Serializer;
import org.simpleframework.xml.core.Persister;
import retrofit.converter.ConversionException;
import retrofit.converter.Converter;
import retrofit.mime.TypedByteArray;
import retrofit.mime.TypedInput;
import retrofit.mime.TypedOutput;

/**
 * A custom {@link retrofit.converter.Converter} to serialize XML data.
 * Same as {@link retrofit.converter.SimpleXMLConverter} but hacked to support our server API.
 */
public class XmlConverter implements Converter {
  private static final String CHARSET = "UTF-8";
  private static final String MIME_TYPE = "application/xml; charset=" + CHARSET;

  private final Serializer serializer;

  public XmlConverter() {
    this(new Persister());
  }

  public XmlConverter(Serializer serializer) {
    this.serializer = serializer;
  }

  // convert InputStream to String
  private static String getStringFromInputStream(InputStream is) {

    BufferedReader br = null;
    StringBuilder sb = new StringBuilder();

    String line;
    try {

      br = new BufferedReader(new InputStreamReader(is));
      while ((line = br.readLine()) != null) {
        sb.append(line);
      }
    } catch (IOException e) {
      e.printStackTrace();
    } finally {
      if (br != null) {
        try {
          br.close();
        } catch (IOException e) {
          e.printStackTrace();
        }
      }
    }

    return sb.toString();
  }

  @Override public Object fromBody(TypedInput body, Type type) throws ConversionException {
    try {
      // Hack : custom queries respond with byte mark characters that InputStream cannot recognize
      // grab the string from the body
      String bodyString = getStringFromInputStream(body.in());
      StringBuffer stringBuffer = new StringBuffer(bodyString);
      int index = stringBuffer.indexOf("xml");
      // clean everything before 'xml'
      stringBuffer.delete(0, index);
      // put '<?' before 'xml'
      stringBuffer.insert(0, "<?");
      // parse this 'cleaned up' string
      return serializer.read((Class<?>) type, stringBuffer.toString());
    } catch (Exception e) {
      throw new ConversionException(e);
    }
  }

  @Override public TypedOutput toBody(Object source) {
    OutputStreamWriter osw = null;

    try {
      ByteArrayOutputStream bos = new ByteArrayOutputStream();
      osw = new OutputStreamWriter(bos, CHARSET);
      serializer.write(source, osw);
      osw.flush();
      return new TypedByteArray(MIME_TYPE, bos.toByteArray());
    } catch (Exception e) {
      throw new AssertionError(e);
    } finally {
      try {
        if (osw != null) {
          osw.close();
        }
      } catch (IOException e) {
        throw new AssertionError(e);
      }
    }
  }
}
