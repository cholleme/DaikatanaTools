//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
//
//  This translation of GLU.H (v1.2) for OpenGL (version 1.1) for Delphi 2.0+
//  has been done by:
//
//  Dipl. Ing. Mike Lischke
//  Straße der Nationen 39
//  09111 Chemnitz
//  Germany
//
//  under consideration of previous translation by
//
//  Richard Hansen
//
//  Artemis Alliance, Inc.
//  289 E. 5th St, #211
//  St. Paul, Mn 55101
//  (612) 227-7172
//  71043.2142@compuserve.com
//
//
//  You may use and distribute it freely for noncommercial use only!
//  Please, do not change the file, but rather send any errors or
//  omissions to
//
//    Lischke@imib.med.tu-dresden.de
//
//  March, 23 1997
//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••


{Copyright (c) 1985-95, Microsoft Corporation

Module Name:

    glu.h

Abstract:

    Procedure declarations, constant definitions and macros for the OpenGL
    Utility Library.



 Copyright 1991-1993, Silicon Graphics, Inc.
 All Rights Reserved.

 This is UNPUBLISHED PROPRIETARY SOURCE CODE of Silicon Graphics, Inc.;
 the contents of this file may not be disclosed to third parties, copied or
 duplicated in any form, in whole or in part, without the prior written
 permission of Silicon Graphics, Inc.

 RESTRICTED RIGHTS LEGEND:
 Use, duplication or disclosure by the Government is subject to restrictions
 as set forth in subdivision (c)(1)(ii) of the Rights in Technical Data
 and Computer Software clause at DFARS 252.227-7013, and/or in similar or
 successor clauses in the FAR, DOD or NASA FAR Supplement. Unpublished -
 rights reserved under the Copyright Laws of the United States.
}

UNIT GLU;

INTERFACE

USES GL;

CONST GLu32 = 'GLu32.DLL';

     // Version
     {$DEFINE GLU_VERSION_1_1}
     {$DEFINE GLU_VERSION_1_2}

     // Errors: (return value 0 = no error)
      GLU_INVALID_ENUM                  = 100900;
      GLU_INVALID_VALUE                 = 100901;
      GLU_OUT_OF_MEMORY                 = 100902;
      GLU_INCOMPATIBLE_GL_VERSION       = 100903;

     // StringName
      GLU_VERSION                       = 100800;
      GLU_EXTENSIONS                    = 100801;

     // Boolean
      GLU_TRUE                          = GL_TRUE;
      GLU_FALSE                         = GL_FALSE;

     //----- Quadric constants -----

     // QuadricNormal
     GLU_SMOOTH                         = 100000;
     GLU_FLAT                           = 100001;
     GLU_NONE                           = 100002;

     // QuadricDrawStyle
     GLU_POINT                          = 100010;
     GLU_LINE                           = 100011;
     GLU_FILL                           = 100012;
     GLU_SILHOUETTE                     = 100013;

     // QuadricOrientation
     GLU_OUTSIDE                        = 100020;
     GLU_INSIDE                         = 100021;

     // Callback types:
     //      GLU_ERROR               100103


     //----- Tesselation constants -----

      GLU_TESS_MAX_COORD                = 1.0E150;

     // TessProperty
      GLU_TESS_WINDING_RULE             = 100140;
      GLU_TESS_BOUNDARY_ONLY            = 100141;
      GLU_TESS_TOLERANCE                = 100142;

     // TessWinding
      GLU_TESS_WINDING_ODD              = 100130;
      GLU_TESS_WINDING_NONZERO          = 100131;
      GLU_TESS_WINDING_POSITIVE         = 100132;
      GLU_TESS_WINDING_NEGATIVE         = 100133;
      GLU_TESS_WINDING_ABS_GEQ_TWO      = 100134;

     // TessCallback
      GLU_TESS_BEGIN                    = 100100;
      GLU_TESS_VERTEX                   = 100101;
      GLU_TESS_END                      = 100102;
      GLU_TESS_ERROR                    = 100103;
      GLU_TESS_EDGE_FLAG                = 100104;
      GLU_TESS_COMBINE                  = 100105;
      GLU_TESS_BEGIN_DATA               = 100106;
      GLU_TESS_VERTEX_DATA              = 100107;
      GLU_TESS_END_DATA                 = 100108;
      GLU_TESS_ERROR_DATA               = 100109;
      GLU_TESS_EDGE_FLAG_DATA           = 100110;
      GLU_TESS_COMBINE_DATA             = 100111;

      // TessError
      GLU_TESS_ERROR1                   = 100151;
      GLU_TESS_ERROR2                   = 100152;
      GLU_TESS_ERROR3                   = 100153;
      GLU_TESS_ERROR4                   = 100154;
      GLU_TESS_ERROR5                   = 100155;
      GLU_TESS_ERROR6                   = 100156;
      GLU_TESS_ERROR7                   = 100157;
      GLU_TESS_ERROR8                   = 100158;

      GLU_TESS_MISSING_BEGIN_POLYGON    = GLU_TESS_ERROR1;
      GLU_TESS_MISSING_BEGIN_CONTOUR    = GLU_TESS_ERROR2;
      GLU_TESS_MISSING_END_POLYGON      = GLU_TESS_ERROR3;
      GLU_TESS_MISSING_END_CONTOUR      = GLU_TESS_ERROR4;
      GLU_TESS_COORD_TOO_LARGE          = GLU_TESS_ERROR5;
      GLU_TESS_NEED_COMBINE_CALLBACK    = GLU_TESS_ERROR6;

     //----- NURBS constants -----

     // NurbsProperty
      GLU_AUTO_LOAD_MATRIX              = 100200;
      GLU_CULLING                       = 100201;
      GLU_SAMPLING_TOLERANCE            = 100203;
      GLU_DISPLAY_MODE                  = 100204;
      GLU_PARAMETRIC_TOLERANCE          = 100202;
      GLU_SAMPLING_METHOD               = 100205;
      GLU_U_STEP                        = 100206;
      GLU_V_STEP                        = 100207;

     // NurbsSampling
      GLU_PATH_LENGTH                   = 100215;
      GLU_PARAMETRIC_ERROR              = 100216;
      GLU_DOMAIN_DISTANCE               = 100217;


     // NurbsTrim
      GLU_MAP1_TRIM_2                   = 100210;
      GLU_MAP1_TRIM_3                   = 100211;

     // NurbsDisplay
     //      GLU_FILL                100012
      GLU_OUTLINE_POLYGON               = 100240;
      GLU_OUTLINE_PATCH                 = 100241;

     // NurbsCallback
     //      GLU_ERROR               100103

     // NurbsErrors
      GLU_NURBS_ERROR1                  = 100251;
      GLU_NURBS_ERROR2                  = 100252;
      GLU_NURBS_ERROR3                  = 100253;
      GLU_NURBS_ERROR4                  = 100254;
      GLU_NURBS_ERROR5                  = 100255;
      GLU_NURBS_ERROR6                  = 100256;
      GLU_NURBS_ERROR7                  = 100257;
      GLU_NURBS_ERROR8                  = 100258;
      GLU_NURBS_ERROR9                  = 100259;
      GLU_NURBS_ERROR10                 = 100260;
      GLU_NURBS_ERROR11                 = 100261;
      GLU_NURBS_ERROR12                 = 100262;
      GLU_NURBS_ERROR13                 = 100263;
      GLU_NURBS_ERROR14                 = 100264;
      GLU_NURBS_ERROR15                 = 100265;
      GLU_NURBS_ERROR16                 = 100266;
      GLU_NURBS_ERROR17                 = 100267;
      GLU_NURBS_ERROR18                 = 100268;
      GLU_NURBS_ERROR19                 = 100269;
      GLU_NURBS_ERROR20                 = 100270;
      GLU_NURBS_ERROR21                 = 100271;
      GLU_NURBS_ERROR22                 = 100272;
      GLU_NURBS_ERROR23                 = 100273;
      GLU_NURBS_ERROR24                 = 100274;
      GLU_NURBS_ERROR25                 = 100275;
      GLU_NURBS_ERROR26                 = 100276;
      GLU_NURBS_ERROR27                 = 100277;
      GLU_NURBS_ERROR28                 = 100278;
      GLU_NURBS_ERROR29                 = 100279;
      GLU_NURBS_ERROR30                 = 100280;
      GLU_NURBS_ERROR31                 = 100281;
      GLU_NURBS_ERROR32                 = 100282;
      GLU_NURBS_ERROR33                 = 100283;
      GLU_NURBS_ERROR34                 = 100284;
      GLU_NURBS_ERROR35                 = 100285;
      GLU_NURBS_ERROR36                 = 100286;
      GLU_NURBS_ERROR37                 = 100287;

      // Contours types -- obsolete!
      GLU_CW                            = 100120;
      GLU_CCW                           = 100121;
      GLU_INTERIOR                      = 100122;
      GLU_EXTERIOR                      = 100123;
      GLU_UNKNOWN                       = 100124;

      // Names without "TESS_" prefix
      GLU_BEGIN                         = GLU_TESS_BEGIN;
      GLU_VERTEX                        = GLU_TESS_VERTEX;
      GLU_END                           = GLU_TESS_END;
      GLU_ERROR                         = GLU_TESS_ERROR;
      GLU_EDGE_FLAG                     = GLU_TESS_EDGE_FLAG;

TYPE THomogenIntVector   = ARRAY[0..3] OF GLint;
     THomogenFloatVector = ARRAY[0..3] OF GLfloat;
     THomogenDblVector   = ARRAY[0..3] OF GLdouble;
     THomogenPtrVector   = ARRAY[0..3] OF Pointer;

     TAffineIntVector    = ARRAY[0..2] OF GLint;
     TAffineFloatVector  = ARRAY[0..2] OF GLfloat;
     TAffineDblVector    = ARRAY[0..2] OF GLdouble;

     THomogenIntMatrix   = ARRAY[0..3,0..3] OF GLint;
     THomogenFloatMatrix = ARRAY[0..3,0..3] OF GLfloat;
     THomogenDblMatrix   = ARRAY[0..3,0..3] OF GLdouble;

     GLUNurbsObj         = RECORD END; PGLUnurbsObj        = ^GLUnurbsObj;
     GLUQuadricObj       = RECORD END; PGLUquadricObj      = ^GLUquadricObj;
     GLUTesselatorObj    = RECORD END; PGLUtesselatorObj   = ^GLUtesselatorObj;
     GLUTriangulatorObj  = RECORD END; PGLUtriangulatorObj = ^GLUtriangulatorObj;

     //----- Callback function types -----
     // gluQuadricCallback
     TGLUQuadricErrorProc = PROCEDURE(error: GLenum); STDCALL;

     // gluTessCallback
     TGLUTesselationCallback  = Pointer;
     TGLUTessBeginProc        = PROCEDURE(atype: GLenum); STDCALL;
     TGLUTessEdgeFlagProc     = PROCEDURE(flag: GLboolean); STDCALL;
     TGLUTessVertexProc       = PROCEDURE(CONST vertex_data); STDCALL;
     TGLUTessEndProc          = PROCEDURE; STDCALL;
     TGLUTessErrorProc        = PROCEDURE(errno: GLenum); STDCALL;
     TGLUTessCombineProc      = PROCEDURE(coords: TAffineDblVector; vertex_data: THomogenPtrVector;
                                          weight: THomogenFloatVector; VAR outData: Pointer); STDCALL;
     TGLUTessBeginDataProc    = PROCEDURE(atype: GLenum; CONST polygon_data); STDCALL;
     TGLUTessEdgeFlagDataProc = PROCEDURE(flag: GLboolean; CONST polygon_data); STDCALL;
     TGLUTessVertexDataProc   = PROCEDURE(CONST vertex_data; CONST polygon_data); STDCALL;
     TGLUTessEndDataProc      = PROCEDURE(CONST polygon_data); STDCALL;
     TGLUTessErrorDataProc    = PROCEDURE(errno: GLenum; CONST polygon_data); STDCALL;
     TGLUTessCombineDataProc  = PROCEDURE(coords: TAffineDblVector; vertex_data: THomogenPtrVector;
                                          weight: THomogenFloatVector; VAR outData: Pointer;
                                          CONST polygon_data); STDCALL;

     // gluNurbsCallback
     TGLUNurbsErrorProc  = PROCEDURE(error: GLenum);

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

// Backwards compatibility for old tesselator

PROCEDURE gluBeginPolygon(tess: PGLUtesselatorObj); STDCALL; EXTERNAL GLu32;
PROCEDURE gluNextContour(tess: PGLUtesselatorObj; atype: GLenum); STDCALL; EXTERNAL GLu32;
PROCEDURE gluEndPolygon(tess: PGLUtesselatorObj); STDCALL; EXTERNAL GLu32;

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

FUNCTION  gluErrorString(errCode: GLenum): PGLubyte; STDCALL; EXTERNAL GLu32;
FUNCTION  gluErrorUnicodeStringEXT(errCode: GLenum): PWideChar; STDCALL; EXTERNAL GLu32;
FUNCTION  gluGetString(name: GLenum): PGLubyte; STDCALL; EXTERNAL GLu32;
PROCEDURE gluOrtho2D(left, right, bottom, top: GLdouble); STDCALL; EXTERNAL GLu32;
PROCEDURE gluPerspective(fovy, aspect, zNear, zFar: GLdouble); STDCALL; EXTERNAL GLu32;
PROCEDURE gluPickMatrix(x, y, width, height: GLdouble; viewport: THomogenIntVector); STDCALL; EXTERNAL GLu32;
PROCEDURE gluLookAt(eyex, eyey, eyez, centerx, centery, centerz, upx, upy, upz: GLdouble); STDCALL; EXTERNAL GLu32;
FUNCTION  gluProject(objx, objy, objz: GLdouble; modelMatrix, projMatrix: THomogenDblMatrix;
                     viewport: THomogenIntVector; winx, winy, winz: PGLdouble): GLBoolean; STDCALL; EXTERNAL GLu32;
FUNCTION  gluUnProject(winx, winy, winz: GLdouble; modelMatrix, projMatrix: THomogenDblMatrix;
                       viewport: THomogenIntVector; objx, objy, objz: PGLdouble): GLBoolean; STDCALL; EXTERNAL GLu32;
FUNCTION  gluScaleImage(format: GLenum; widthin, heightin: GLint; typein: GLenum; CONST datain;
                        widthout, heightout: GLint; typeout: GLenum; VAR dataout): GLint; STDCALL; EXTERNAL GLu32;
FUNCTION  gluBuild1DMipmaps(target: GLenum; components, width: GLint; format, atype: GLenum;
                            CONST data): GLint; STDCALL; EXTERNAL GLu32;
FUNCTION  gluBuild2DMipmaps(target: GLenum; components, width, height: GLint; format, atype: GLenum;
                            CONST data): GLint; STDCALL; EXTERNAL GLu32;
FUNCTION  gluNewQuadric: PGLUQuadricObj; STDCALL; EXTERNAL GLu32;
PROCEDURE gluDeleteQuadric(state: PGLUQuadricObj); STDCALL; EXTERNAL GLu32;
PROCEDURE gluQuadricNormals(quadObject: PGLuQuadricObj; normals: GLenum); STDCALL; EXTERNAL GLu32;
PROCEDURE gluQuadricTexture(quadObject: PGLuQuadricObj; textureCoords: GLboolean); STDCALL; EXTERNAL GLu32;
PROCEDURE gluQuadricOrientation(quadObject: PGLuQuadricObj; orientation: GLenum); STDCALL; EXTERNAL GLu32;
PROCEDURE gluQuadricDrawStyle(quadObject: PGLuQuadricObj; drawStyle: GLenum); STDCALL; EXTERNAL GLu32;
PROCEDURE gluCylinder(qobj: PGLuQuadricObj; baseRadius, topRadius, height: GLdouble;
                      slices, stacks: GLint); STDCALL; EXTERNAL GLu32;
PROCEDURE gluDisk(qobj: PGLuQuadricObj; innerRadius, outerRadius: GLdouble;
                  slices, loops: GLint); STDCALL; EXTERNAL GLu32;
PROCEDURE gluPartialDisk(qobj: PGLuQuadricObj; innerRadius, outerRadius: GLdouble;
                         slices, loops: GLint; startAngle, sweepAngle: GLdouble); STDCALL; EXTERNAL GLu32;
PROCEDURE gluSphere(qobj: PGLuQuadricObj; radius: GLdouble; slices, stacks: GLint); STDCALL; EXTERNAL GLu32;
PROCEDURE gluQuadricCallback(qobj: PGLuQuadricObj; which: GLenum; fn: TGLUQuadricErrorProc); STDCALL; EXTERNAL GLu32;
FUNCTION  gluNewTess: PGLUtesselatorObj; STDCALL; EXTERNAL GLu32;
PROCEDURE gluDeleteTess(tess: PGLUtesselatorObj); STDCALL; EXTERNAL GLu32;
PROCEDURE gluTessBeginPolygon(tess: PGLUtesselatorObj; CONST polygon_data ); STDCALL; EXTERNAL GLu32;
PROCEDURE gluTessBeginContour(tess: PGLUtesselatorObj); STDCALL; EXTERNAL GLu32;
PROCEDURE gluTessVertex(tess: PGLUtesselatorObj; coords: TAffineDblVector; CONST data ); STDCALL; EXTERNAL GLu32;
PROCEDURE gluTessEndContour(tess: PGLUtesselatorObj); STDCALL; EXTERNAL GLu32;
PROCEDURE gluTessEndPolygon(tess: PGLUtesselatorObj); STDCALL; EXTERNAL GLu32;
PROCEDURE gluTessProperty(tess: PGLUtesselatorObj; which: GLenum; value: GLdouble); STDCALL; EXTERNAL GLu32;
PROCEDURE gluTessNormal(tess: PGLUtesselatorObj; x, y, z: GLdouble); STDCALL; EXTERNAL GLu32;
PROCEDURE gluTessCallback(tess: PGLUtesselatorObj; which: GLenum; fn: TGLUTesselationCallback); STDCALL; EXTERNAL GLu32;
PROCEDURE gluGetTessProperty(tess: PGLUtesselatorObj; which: GLenum; value: PGLdouble); STDCALL; EXTERNAL GLu32;
FUNCTION  gluNewNurbsRenderer: PGLUnurbsObj; STDCALL; EXTERNAL GLu32;
PROCEDURE gluDeleteNurbsRenderer(nobj: PGLUnurbsObj); STDCALL; EXTERNAL GLu32;
PROCEDURE gluBeginSurface(nobj: PGLUnurbsObj); STDCALL; EXTERNAL GLu32;
PROCEDURE gluBeginCurve (nobj: PGLUnurbsObj); STDCALL; EXTERNAL GLu32;
PROCEDURE gluEndCurve(nobj: PGLUnurbsObj); STDCALL; EXTERNAL GLu32;
PROCEDURE gluEndSurface(nobj: PGLUnurbsObj); STDCALL; EXTERNAL GLu32;
PROCEDURE gluBeginTrim(nobj: PGLUnurbsObj); STDCALL; EXTERNAL GLu32;
PROCEDURE gluEndTrim(nobj: PGLUnurbsObj); STDCALL; EXTERNAL GLu32;
PROCEDURE gluPwlCurve(nobj: PGLUnurbsObj; count: GLint; aarray: PGLfloat; stride: GLint;
                      atype: GLint); STDCALL; EXTERNAL GLu32;
PROCEDURE gluNurbsCurve(nobj: PGLUnurbsObj; nknots: GLint; knot: PGLfloat; stride: GLint;
                        ctlarray: PGLfloat; order: GLint; atype: GLenum); STDCALL; EXTERNAL GLu32;
PROCEDURE gluNurbsSurface(nobj: PGLUnurbsObj; sknot_count: GLint; sknot: PGLfloat; tknot_count: GLint;
                          tknot: PGLfloat; s_stride, t_stride: GLint; ctlarray: PGLfloat;
                          sorder, torder: GLint; atype: GLenum); STDCALL; EXTERNAL GLu32;
PROCEDURE gluLoadSamplingMatrices(nobj: PGLUnurbsObj; CONST modelMatrix, projMatrix: THomogenFloatMatrix;
                                  CONST viewport: THomogenIntVector); STDCALL; EXTERNAL GLu32;
PROCEDURE gluNurbsProperty(nobj: PGLUnurbsObj; aproperty: GLenum; value: GLfloat); STDCALL; EXTERNAL GLu32;
PROCEDURE gluGetNurbsProperty(nobj: PGLUnurbsObj; aproperty: GLenum; value: PGLfloat); STDCALL; EXTERNAL GLu32;
PROCEDURE gluNurbsCallback(nobj: PGLUnurbsObj; which: GLenum; fn: TGLUNurbsErrorProc); STDCALL; EXTERNAL GLu32;

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

IMPLEMENTATION

END.
