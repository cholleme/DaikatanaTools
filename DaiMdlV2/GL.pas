//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
//
//  This translation of GL.H for OpenGL (version 1.1) for Delphi 2.0+
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
//  March, 22 1997
//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••


{Copyright (c) 1985-96, Microsoft Corporation

Module Name:

    gl.h

Abstract:

    Procedure declarations, constant definitions and macros for the OpenGL
    component.


 Copyright 1996 Silicon Graphics, Inc.
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

UNIT GL;

{$MODE Delphi}

INTERFACE

USES Windows,fpu;

TYPE GLenum      = UINT;      PGLenum     = ^GLenum;
     GLboolean   = Boolean;   PGLboolean  = ^GLboolean;
     GLbitfield  = UINT;      PGLbitfield = ^GLbitfield;
     GLbyte      = ShortInt;  PGLbyte     = ^GLbyte;
     GLshort     = SHORT;     PGLshort    = ^GLshort;
     GLint       = Integer;   PGLint      = ^GLint;
     GLsizei     = Integer;   PGLsizei    = ^GLsizei;
     GLubyte     = UCHAR;     PGLubyte    = ^GLubyte;
     GLushort    = Word;      PGLushort   = ^GLushort;
     GLuint      = UINT;      PGLuint     = ^GLuint;
     GLfloat     = Single;    PGLfloat    = ^GLfloat;
     GLclampf    = Single;    PGLclampf   = ^GLclampf;
     GLdouble    = Double;    PGLdouble   = ^GLdouble;
     GLclampd    = Double;    PGLclampd   = ^GLclampd;

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

// Version

{$DEFINE GL_VERSION_1_1}

CONST // AccumOp
      GL_ACCUM                          = $0100;
      GL_LOAD                           = $0101;
      GL_RETURN                         = $0102;
      GL_MULT                           = $0103;
      GL_ADD                            = $0104;

      // AlphaFunction
      GL_NEVER                          = $0200;
      GL_LESS                           = $0201;
      GL_EQUAL                          = $0202;
      GL_LEQUAL                         = $0203;
      GL_GREATER                        = $0204;
      GL_NOTEQUAL                       = $0205;
      GL_GEQUAL                         = $0206;
      GL_ALWAYS                         = $0207;

      // AttribMask
      GL_CURRENT_BIT                    = $00000001;
      GL_POINT_BIT                      = $00000002;
      GL_LINE_BIT                       = $00000004;
      GL_POLYGON_BIT                    = $00000008;
      GL_POLYGON_STIPPLE_BIT            = $00000010;
      GL_PIXEL_MODE_BIT                 = $00000020;
      GL_LIGHTING_BIT                   = $00000040;
      GL_FOG_BIT                        = $00000080;
      GL_DEPTH_BUFFER_BIT               = $00000100;
      GL_ACCUM_BUFFER_BIT               = $00000200;
      GL_STENCIL_BUFFER_BIT             = $00000400;
      GL_VIEWPORT_BIT                   = $00000800;
      GL_TRANSFORM_BIT                  = $00001000;
      GL_ENABLE_BIT                     = $00002000;
      GL_COLOR_BUFFER_BIT               = $00004000;
      GL_HINT_BIT                       = $00008000;
      GL_EVAL_BIT                       = $00010000;
      GL_LIST_BIT                       = $00020000;
      GL_TEXTURE_BIT                    = $00040000;
      GL_SCISSOR_BIT                    = $00080000;
      GL_ALL_ATTRIB_BITS                = $000fffff;

      // BeginMode
      GL_POINTS                         = $0000;
      GL_LINES                          = $0001;
      GL_LINE_LOOP                      = $0002;
      GL_LINE_STRIP                     = $0003;
      GL_TRIANGLES                      = $0004;
      GL_TRIANGLE_STRIP                 = $0005;
      GL_TRIANGLE_FAN                   = $0006;
      GL_QUADS                          = $0007;
      GL_QUAD_STRIP                     = $0008;
      GL_POLYGON                        = $0009;

      // BlendingFactorDest
      GL_ZERO                           = 0;
      GL_ONE                            = 1;
      GL_SRC_COLOR                      = $0300;
      GL_ONE_MINUS_SRC_COLOR            = $0301;
      GL_SRC_ALPHA                      = $0302;
      GL_ONE_MINUS_SRC_ALPHA            = $0303;
      GL_DST_ALPHA                      = $0304;
      GL_ONE_MINUS_DST_ALPHA            = $0305;

      // BlendingFactorSrc
      //      GL_ZERO
      //      GL_ONE
      GL_DST_COLOR                      = $0306;
      GL_ONE_MINUS_DST_COLOR            = $0307;
      GL_SRC_ALPHA_SATURATE             = $0308;
      //      GL_SRC_ALPHA
      //      GL_ONE_MINUS_SRC_ALPHA
      //      GL_DST_ALPHA
      //      GL_ONE_MINUS_DST_ALPHA

      // Boolean
      GL_TRUE                           = True;
      GL_FALSE                          = False;

      // ClearBufferMask
      //      GL_COLOR_BUFFER_BIT
      //      GL_ACCUM_BUFFER_BIT
      //      GL_STENCIL_BUFFER_BIT
      //      GL_DEPTH_BUFFER_BIT

      // ClientArrayType
      //      GL_VERTEX_ARRAY
      //      GL_NORMAL_ARRAY
      //      GL_COLOR_ARRAY
      //      GL_INDEX_ARRAY
      //      GL_TEXTURE_COORD_ARRAY
      //      GL_EDGE_FLAG_ARRAY

      // ClipPlaneName
      GL_CLIP_PLANE0                    = $3000;
      GL_CLIP_PLANE1                    = $3001;
      GL_CLIP_PLANE2                    = $3002;
      GL_CLIP_PLANE3                    = $3003;
      GL_CLIP_PLANE4                    = $3004;
      GL_CLIP_PLANE5                    = $3005;

      // ColorMaterialFace
      //      GL_FRONT
      //      GL_BACK
      //      GL_FRONT_AND_BACK 

      // ColorMaterialParameter 
      //      GL_AMBIENT 
      //      GL_DIFFUSE
      //      GL_SPECULAR 
      //      GL_EMISSION 
      //      GL_AMBIENT_AND_DIFFUSE 

      // ColorPointerType 
      //      GL_BYTE 
      //      GL_UNSIGNED_BYTE 
      //      GL_SHORT 
      //      GL_UNSIGNED_SHORT
      //      GL_INT 
      //      GL_UNSIGNED_INT 
      //      GL_FLOAT 
      //      GL_DOUBLE 

      // CullFaceMode
      //      GL_FRONT 
      //      GL_BACK 
      //      GL_FRONT_AND_BACK 

      // DataType
      GL_BYTE                           = $1400;
      GL_UNSIGNED_BYTE                  = $1401;
      GL_SHORT                          = $1402;
      GL_UNSIGNED_SHORT                 = $1403;
      GL_INT                            = $1404;
      GL_UNSIGNED_INT                   = $1405;
      GL_FLOAT                          = $1406;
      GL_2_BYTES                        = $1407;
      GL_3_BYTES                        = $1408;
      GL_4_BYTES                        = $1409;
      GL_DOUBLE                         = $140A;

      // DepthFunction
      //      GL_NEVER
      //      GL_LESS
      //      GL_EQUAL
      //      GL_LEQUAL
      //      GL_GREATER
      //      GL_NOTEQUAL
      //      GL_GEQUAL
      //      GL_ALWAYS

      // DrawBufferMode
      GL_NONE                           = 0;
      GL_FRONT_LEFT                     = $0400;
      GL_FRONT_RIGHT                    = $0401;
      GL_BACK_LEFT                      = $0402;
      GL_BACK_RIGHT                     = $0403;
      GL_FRONT                          = $0404;
      GL_BACK                           = $0405;
      GL_LEFT                           = $0406;
      GL_RIGHT                          = $0407;
      GL_FRONT_AND_BACK                 = $0408;
      GL_AUX0                           = $0409;
      GL_AUX1                           = $040A;
      GL_AUX2                           = $040B;
      GL_AUX3                           = $040C;

      // Enable
      //      GL_FOG
      //      GL_LIGHTING
      //      GL_TEXTURE_1D
      //      GL_TEXTURE_2D
      //      GL_LINE_STIPPLE
      //      GL_POLYGON_STIPPLE
      //      GL_CULL_FACE
      //      GL_ALPHA_TEST
      //      GL_BLEND
      //      GL_INDEX_LOGIC_OP
      //      GL_COLOR_LOGIC_OP
      //      GL_DITHER
      //      GL_STENCIL_TEST
      //      GL_DEPTH_TEST
      //      GL_CLIP_PLANE0
      //      GL_CLIP_PLANE1
      //      GL_CLIP_PLANE2
      //      GL_CLIP_PLANE3
      //      GL_CLIP_PLANE4
      //      GL_CLIP_PLANE5
      //      GL_LIGHT0 
      //      GL_LIGHT1
      //      GL_LIGHT2 
      //      GL_LIGHT3 
      //      GL_LIGHT4 
      //      GL_LIGHT5 
      //      GL_LIGHT6 
      //      GL_LIGHT7 
      //      GL_TEXTURE_GEN_S 
      //      GL_TEXTURE_GEN_T 
      //      GL_TEXTURE_GEN_R 
      //      GL_TEXTURE_GEN_Q 
      //      GL_MAP1_VERTEX_3 
      //      GL_MAP1_VERTEX_4 
      //      GL_MAP1_COLOR_4
      //      GL_MAP1_INDEX 
      //      GL_MAP1_NORMAL 
      //      GL_MAP1_TEXTURE_COORD_1 
      //      GL_MAP1_TEXTURE_COORD_2 
      //      GL_MAP1_TEXTURE_COORD_3
      //      GL_MAP1_TEXTURE_COORD_4
      //      GL_MAP2_VERTEX_3 
      //      GL_MAP2_VERTEX_4 
      //      GL_MAP2_COLOR_4 
      //      GL_MAP2_INDEX 
      //      GL_MAP2_NORMAL 
      //      GL_MAP2_TEXTURE_COORD_1 
      //      GL_MAP2_TEXTURE_COORD_2 
      //      GL_MAP2_TEXTURE_COORD_3 
      //      GL_MAP2_TEXTURE_COORD_4 
      //      GL_POINT_SMOOTH 
      //      GL_LINE_SMOOTH 
      //      GL_POLYGON_SMOOTH 
      //      GL_SCISSOR_TEST 
      //      GL_COLOR_MATERIAL
      //      GL_NORMALIZE
      //      GL_AUTO_NORMAL 
      //      GL_VERTEX_ARRAY
      //      GL_NORMAL_ARRAY
      //      GL_COLOR_ARRAY
      //      GL_INDEX_ARRAY
      //      GL_TEXTURE_COORD_ARRAY
      //      GL_EDGE_FLAG_ARRAY
      //      GL_POLYGON_OFFSET_POINT
      //      GL_POLYGON_OFFSET_LINE
      //      GL_POLYGON_OFFSET_FILL

      // ErrorCode
      GL_NO_ERROR                       = 0;
      GL_INVALID_ENUM                   = $0500;
      GL_INVALID_VALUE                  = $0501;
      GL_INVALID_OPERATION              = $0502;
      GL_STACK_OVERFLOW                 = $0503;
      GL_STACK_UNDERFLOW                = $0504;
      GL_OUT_OF_MEMORY                  = $0505;

      // FeedBackMode
      GL_2D                             = $0600;
      GL_3D                             = $0601;
      GL_3D_COLOR                       = $0602;
      GL_3D_COLOR_TEXTURE               = $0603;
      GL_4D_COLOR_TEXTURE               = $0604;

      // FeedBackToken
      GL_PASS_THROUGH_TOKEN             = $0700;
      GL_POINT_TOKEN                    = $0701;
      GL_LINE_TOKEN                     = $0702;
      GL_POLYGON_TOKEN                  = $0703;
      GL_BITMAP_TOKEN                   = $0704;
      GL_DRAW_PIXEL_TOKEN               = $0705;
      GL_COPY_PIXEL_TOKEN               = $0706;
      GL_LINE_RESET_TOKEN               = $0707;

      // FogMode
      //      GL_LINEAR
      GL_EXP                            = $0800;
      GL_EXP2                           = $0801;

      // FogParameter
      //      GL_FOG_COLOR
      //      GL_FOG_DENSITY
      //      GL_FOG_END
      //      GL_FOG_INDEX
      //      GL_FOG_MODE
      //      GL_FOG_START

      // FrontFaceDirection
      GL_CW                             = $0900;
      GL_CCW                            = $0901;

      // GetMapTarget
      GL_COEFF                          = $0A00;
      GL_ORDER                          = $0A01;
      GL_DOMAIN                         = $0A02;

      // GetPixelMap
      //      GL_PIXEL_MAP_I_TO_I
      //      GL_PIXEL_MAP_S_TO_S
      //      GL_PIXEL_MAP_I_TO_R
      //      GL_PIXEL_MAP_I_TO_G
      //      GL_PIXEL_MAP_I_TO_B
      //      GL_PIXEL_MAP_I_TO_A
      //      GL_PIXEL_MAP_R_TO_R
      //      GL_PIXEL_MAP_G_TO_G
      //      GL_PIXEL_MAP_B_TO_B
      //      GL_PIXEL_MAP_A_TO_A

      // GetPointerTarget
      //      GL_VERTEX_ARRAY_POINTER
      //      GL_NORMAL_ARRAY_POINTER
      //      GL_COLOR_ARRAY_POINTER
      //      GL_INDEX_ARRAY_POINTER
      //      GL_TEXTURE_COORD_ARRAY_POINTER
      //      GL_EDGE_FLAG_ARRAY_POINTER

      // GetTarget
      GL_CURRENT_COLOR                  = $0B00;
      GL_CURRENT_INDEX                  = $0B01;
      GL_CURRENT_NORMAL                 = $0B02;
      GL_CURRENT_TEXTURE_COORDS         = $0B03;
      GL_CURRENT_RASTER_COLOR           = $0B04;
      GL_CURRENT_RASTER_INDEX           = $0B05;
      GL_CURRENT_RASTER_TEXTURE_COORDS  = $0B06;
      GL_CURRENT_RASTER_POSITION        = $0B07;
      GL_CURRENT_RASTER_POSITION_VALID  = $0B08;
      GL_CURRENT_RASTER_DISTANCE        = $0B09;
      GL_POINT_SMOOTH                   = $0B10;
      GL_POINT_SIZE                     = $0B11;
      GL_POINT_SIZE_RANGE               = $0B12;
      GL_POINT_SIZE_GRANULARITY         = $0B13;
      GL_LINE_SMOOTH                    = $0B20;
      GL_LINE_WIDTH                     = $0B21;
      GL_LINE_WIDTH_RANGE               = $0B22;
      GL_LINE_WIDTH_GRANULARITY         = $0B23;
      GL_LINE_STIPPLE                   = $0B24;
      GL_LINE_STIPPLE_PATTERN           = $0B25;
      GL_LINE_STIPPLE_REPEAT            = $0B26;
      GL_LIST_MODE                      = $0B30;
      GL_MAX_LIST_NESTING               = $0B31;
      GL_LIST_BASE                      = $0B32;
      GL_LIST_INDEX                     = $0B33;
      GL_POLYGON_MODE                   = $0B40;
      GL_POLYGON_SMOOTH                 = $0B41;
      GL_POLYGON_STIPPLE                = $0B42;
      GL_EDGE_FLAG                      = $0B43;
      GL_CULL_FACE                      = $0B44;
      GL_CULL_FACE_MODE                 = $0B45;
      GL_FRONT_FACE                     = $0B46;
      GL_LIGHTING                       = $0B50;
      GL_LIGHT_MODEL_LOCAL_VIEWER       = $0B51;
      GL_LIGHT_MODEL_TWO_SIDE           = $0B52;
      GL_LIGHT_MODEL_AMBIENT            = $0B53;
      GL_SHADE_MODEL                    = $0B54;
      GL_COLOR_MATERIAL_FACE            = $0B55;
      GL_COLOR_MATERIAL_PARAMETER       = $0B56;
      GL_COLOR_MATERIAL                 = $0B57;
      GL_FOG                            = $0B60;
      GL_FOG_INDEX                      = $0B61;
      GL_FOG_DENSITY                    = $0B62;
      GL_FOG_START                      = $0B63;
      GL_FOG_END                        = $0B64;
      GL_FOG_MODE                       = $0B65;
      GL_FOG_COLOR                      = $0B66;
      GL_DEPTH_RANGE                    = $0B70;
      GL_DEPTH_TEST                     = $0B71;
      GL_DEPTH_WRITEMASK                = $0B72;
      GL_DEPTH_CLEAR_VALUE              = $0B73;
      GL_DEPTH_FUNC                     = $0B74;
      GL_ACCUM_CLEAR_VALUE              = $0B80;
      GL_STENCIL_TEST                   = $0B90;
      GL_STENCIL_CLEAR_VALUE            = $0B91;
      GL_STENCIL_FUNC                   = $0B92;
      GL_STENCIL_VALUE_MASK             = $0B93;
      GL_STENCIL_FAIL                   = $0B94;
      GL_STENCIL_PASS_DEPTH_FAIL        = $0B95;
      GL_STENCIL_PASS_DEPTH_PASS        = $0B96;
      GL_STENCIL_REF                    = $0B97;
      GL_STENCIL_WRITEMASK              = $0B98;
      GL_MATRIX_MODE                    = $0BA0;
      GL_NORMALIZE                      = $0BA1;
      GL_VIEWPORT                       = $0BA2;
      GL_MODELVIEW_STACK_DEPTH          = $0BA3;
      GL_PROJECTION_STACK_DEPTH         = $0BA4;
      GL_TEXTURE_STACK_DEPTH            = $0BA5;
      GL_MODELVIEW_MATRIX               = $0BA6;
      GL_PROJECTION_MATRIX              = $0BA7;
      GL_TEXTURE_MATRIX                 = $0BA8;
      GL_ATTRIB_STACK_DEPTH             = $0BB0;
      GL_CLIENT_ATTRIB_STACK_DEPTH      = $0BB1;
      GL_ALPHA_TEST                     = $0BC0;
      GL_ALPHA_TEST_FUNC                = $0BC1;
      GL_ALPHA_TEST_REF                 = $0BC2;
      GL_DITHER                         = $0BD0;
      GL_BLEND_DST                      = $0BE0;
      GL_BLEND_SRC                      = $0BE1;
      GL_BLEND                          = $0BE2;
      GL_LOGIC_OP_MODE                  = $0BF0;
      GL_INDEX_LOGIC_OP                 = $0BF1;
      GL_COLOR_LOGIC_OP                 = $0BF2;
      GL_AUX_BUFFERS                    = $0C00;
      GL_DRAW_BUFFER                    = $0C01;
      GL_READ_BUFFER                    = $0C02;
      GL_SCISSOR_BOX                    = $0C10;
      GL_SCISSOR_TEST                   = $0C11;
      GL_INDEX_CLEAR_VALUE              = $0C20;
      GL_INDEX_WRITEMASK                = $0C21;
      GL_COLOR_CLEAR_VALUE              = $0C22;
      GL_COLOR_WRITEMASK                = $0C23;
      GL_INDEX_MODE                     = $0C30;
      GL_RGBA_MODE                      = $0C31;
      GL_DOUBLEBUFFER                   = $0C32;
      GL_STEREO                         = $0C33;
      GL_RENDER_MODE                    = $0C40;
      GL_PERSPECTIVE_CORRECTION_HINT    = $0C50;
      GL_POINT_SMOOTH_HINT              = $0C51;
      GL_LINE_SMOOTH_HINT               = $0C52;
      GL_POLYGON_SMOOTH_HINT            = $0C53;
      GL_FOG_HINT                       = $0C54;
      GL_TEXTURE_GEN_S                  = $0C60;
      GL_TEXTURE_GEN_T                  = $0C61;
      GL_TEXTURE_GEN_R                  = $0C62;
      GL_TEXTURE_GEN_Q                  = $0C63;
      GL_PIXEL_MAP_I_TO_I               = $0C70;
      GL_PIXEL_MAP_S_TO_S               = $0C71;
      GL_PIXEL_MAP_I_TO_R               = $0C72;
      GL_PIXEL_MAP_I_TO_G               = $0C73;
      GL_PIXEL_MAP_I_TO_B               = $0C74;
      GL_PIXEL_MAP_I_TO_A               = $0C75;
      GL_PIXEL_MAP_R_TO_R               = $0C76;
      GL_PIXEL_MAP_G_TO_G               = $0C77;
      GL_PIXEL_MAP_B_TO_B               = $0C78;
      GL_PIXEL_MAP_A_TO_A               = $0C79;
      GL_PIXEL_MAP_I_TO_I_SIZE          = $0CB0;
      GL_PIXEL_MAP_S_TO_S_SIZE          = $0CB1;
      GL_PIXEL_MAP_I_TO_R_SIZE          = $0CB2;
      GL_PIXEL_MAP_I_TO_G_SIZE          = $0CB3;
      GL_PIXEL_MAP_I_TO_B_SIZE          = $0CB4;
      GL_PIXEL_MAP_I_TO_A_SIZE          = $0CB5;
      GL_PIXEL_MAP_R_TO_R_SIZE          = $0CB6;
      GL_PIXEL_MAP_G_TO_G_SIZE          = $0CB7;
      GL_PIXEL_MAP_B_TO_B_SIZE          = $0CB8;
      GL_PIXEL_MAP_A_TO_A_SIZE          = $0CB9;
      GL_UNPACK_SWAP_BYTES              = $0CF0;
      GL_UNPACK_LSB_FIRST               = $0CF1;
      GL_UNPACK_ROW_LENGTH              = $0CF2;
      GL_UNPACK_SKIP_ROWS               = $0CF3;
      GL_UNPACK_SKIP_PIXELS             = $0CF4;
      GL_UNPACK_ALIGNMENT               = $0CF5;
      GL_PACK_SWAP_BYTES                = $0D00;
      GL_PACK_LSB_FIRST                 = $0D01;
      GL_PACK_ROW_LENGTH                = $0D02;
      GL_PACK_SKIP_ROWS                 = $0D03;
      GL_PACK_SKIP_PIXELS               = $0D04;
      GL_PACK_ALIGNMENT                 = $0D05;
      GL_MAP_COLOR                      = $0D10;
      GL_MAP_STENCIL                    = $0D11;
      GL_INDEX_SHIFT                    = $0D12;
      GL_INDEX_OFFSET                   = $0D13;
      GL_RED_SCALE                      = $0D14;
      GL_RED_BIAS                       = $0D15;
      GL_ZOOM_X                         = $0D16;
      GL_ZOOM_Y                         = $0D17;
      GL_GREEN_SCALE                    = $0D18;
      GL_GREEN_BIAS                     = $0D19;
      GL_BLUE_SCALE                     = $0D1A;
      GL_BLUE_BIAS                      = $0D1B;
      GL_ALPHA_SCALE                    = $0D1C;
      GL_ALPHA_BIAS                     = $0D1D;
      GL_DEPTH_SCALE                    = $0D1E;
      GL_DEPTH_BIAS                     = $0D1F;
      GL_MAX_EVAL_ORDER                 = $0D30;
      GL_MAX_LIGHTS                     = $0D31;
      GL_MAX_CLIP_PLANES                = $0D32;
      GL_MAX_TEXTURE_SIZE               = $0D33;
      GL_MAX_PIXEL_MAP_TABLE            = $0D34;
      GL_MAX_ATTRIB_STACK_DEPTH         = $0D35;
      GL_MAX_MODELVIEW_STACK_DEPTH      = $0D36;
      GL_MAX_NAME_STACK_DEPTH           = $0D37;
      GL_MAX_PROJECTION_STACK_DEPTH     = $0D38;
      GL_MAX_TEXTURE_STACK_DEPTH        = $0D39;
      GL_MAX_VIEWPORT_DIMS              = $0D3A;
      GL_MAX_CLIENT_ATTRIB_STACK_DEPTH  = $0D3B;
      GL_SUBPIXEL_BITS                  = $0D50;
      GL_INDEX_BITS                     = $0D51;
      GL_RED_BITS                       = $0D52;
      GL_GREEN_BITS                     = $0D53;
      GL_BLUE_BITS                      = $0D54;
      GL_ALPHA_BITS                     = $0D55;
      GL_DEPTH_BITS                     = $0D56;
      GL_STENCIL_BITS                   = $0D57;
      GL_ACCUM_RED_BITS                 = $0D58;
      GL_ACCUM_GREEN_BITS               = $0D59;
      GL_ACCUM_BLUE_BITS                = $0D5A;
      GL_ACCUM_ALPHA_BITS               = $0D5B;
      GL_NAME_STACK_DEPTH               = $0D70;
      GL_AUTO_NORMAL                    = $0D80;
      GL_MAP1_COLOR_4                   = $0D90;
      GL_MAP1_INDEX                     = $0D91;
      GL_MAP1_NORMAL                    = $0D92;
      GL_MAP1_TEXTURE_COORD_1           = $0D93;
      GL_MAP1_TEXTURE_COORD_2           = $0D94;
      GL_MAP1_TEXTURE_COORD_3           = $0D95;
      GL_MAP1_TEXTURE_COORD_4           = $0D96;
      GL_MAP1_VERTEX_3                  = $0D97;
      GL_MAP1_VERTEX_4                  = $0D98;
      GL_MAP2_COLOR_4                   = $0DB0;
      GL_MAP2_INDEX                     = $0DB1;
      GL_MAP2_NORMAL                    = $0DB2;
      GL_MAP2_TEXTURE_COORD_1           = $0DB3;
      GL_MAP2_TEXTURE_COORD_2           = $0DB4;
      GL_MAP2_TEXTURE_COORD_3           = $0DB5;
      GL_MAP2_TEXTURE_COORD_4           = $0DB6;
      GL_MAP2_VERTEX_3                  = $0DB7;
      GL_MAP2_VERTEX_4                  = $0DB8;
      GL_MAP1_GRID_DOMAIN               = $0DD0;
      GL_MAP1_GRID_SEGMENTS             = $0DD1;
      GL_MAP2_GRID_DOMAIN               = $0DD2;
      GL_MAP2_GRID_SEGMENTS             = $0DD3;
      GL_TEXTURE_1D                     = $0DE0;
      GL_TEXTURE_2D                     = $0DE1;
      GL_FEEDBACK_BUFFER_POINTER        = $0DF0;
      GL_FEEDBACK_BUFFER_SIZE           = $0DF1;
      GL_FEEDBACK_BUFFER_TYPE           = $0DF2;
      GL_SELECTION_BUFFER_POINTER       = $0DF3;
      GL_SELECTION_BUFFER_SIZE          = $0DF4;
      //      GL_TEXTURE_BINDING_1D
      //      GL_TEXTURE_BINDING_2D
      //      GL_VERTEX_ARRAY
      //      GL_NORMAL_ARRAY
      //      GL_COLOR_ARRAY
      //      GL_INDEX_ARRAY
      //      GL_TEXTURE_COORD_ARRAY
      //      GL_EDGE_FLAG_ARRAY
      //      GL_VERTEX_ARRAY_SIZE
      //      GL_VERTEX_ARRAY_TYPE
      //      GL_VERTEX_ARRAY_STRIDE
      //      GL_NORMAL_ARRAY_TYPE
      //      GL_NORMAL_ARRAY_STRIDE
      //      GL_COLOR_ARRAY_SIZE
      //      GL_COLOR_ARRAY_TYPE
      //      GL_COLOR_ARRAY_STRIDE
      //      GL_INDEX_ARRAY_TYPE
      //      GL_INDEX_ARRAY_STRIDE
      //      GL_TEXTURE_COORD_ARRAY_SIZE
      //      GL_TEXTURE_COORD_ARRAY_TYPE
      //      GL_TEXTURE_COORD_ARRAY_STRIDE
      //      GL_EDGE_FLAG_ARRAY_STRIDE
      //      GL_POLYGON_OFFSET_FACTOR
      //      GL_POLYGON_OFFSET_UNITS 

      // GetTextureParameter 
      //      GL_TEXTURE_MAG_FILTER 
      //      GL_TEXTURE_MIN_FILTER 
      //      GL_TEXTURE_WRAP_S 
      //      GL_TEXTURE_WRAP_T 
      GL_TEXTURE_WIDTH                  = $1000;
      GL_TEXTURE_HEIGHT                 = $1001;
      GL_TEXTURE_INTERNAL_FORMAT        = $1003;
      GL_TEXTURE_BORDER_COLOR           = $1004;
      GL_TEXTURE_BORDER                 = $1005;
      //      GL_TEXTURE_RED_SIZE
      //      GL_TEXTURE_GREEN_SIZE
      //      GL_TEXTURE_BLUE_SIZE
      //      GL_TEXTURE_ALPHA_SIZE
      //      GL_TEXTURE_LUMINANCE_SIZE
      //      GL_TEXTURE_INTENSITY_SIZE
      //      GL_TEXTURE_PRIORITY
      //      GL_TEXTURE_RESIDENT

      // HintMode
      GL_DONT_CARE                      = $1100;
      GL_FASTEST                        = $1101;
      GL_NICEST                         = $1102;

      // HintTarget
      //      GL_PERSPECTIVE_CORRECTION_HINT
      //      GL_POINT_SMOOTH_HINT
      //      GL_LINE_SMOOTH_HINT
      //      GL_POLYGON_SMOOTH_HINT
      //      GL_FOG_HINT

      // IndexPointerType
      //      GL_SHORT
      //      GL_INT
      //      GL_FLOAT
      //      GL_DOUBLE

      // LightModelParameter
      //      GL_LIGHT_MODEL_AMBIENT
      //      GL_LIGHT_MODEL_LOCAL_VIEWER
      //      GL_LIGHT_MODEL_TWO_SIDE

      // LightName
      GL_LIGHT0                         = $4000;
      GL_LIGHT1                         = $4001;
      GL_LIGHT2                         = $4002;
      GL_LIGHT3                         = $4003;
      GL_LIGHT4                         = $4004;
      GL_LIGHT5                         = $4005;
      GL_LIGHT6                         = $4006;
      GL_LIGHT7                         = $4007;

      // LightParameter
      GL_AMBIENT                        = $1200;
      GL_DIFFUSE                        = $1201;
      GL_SPECULAR                       = $1202;
      GL_POSITION                       = $1203;
      GL_SPOT_DIRECTION                 = $1204;
      GL_SPOT_EXPONENT                  = $1205;
      GL_SPOT_CUTOFF                    = $1206;
      GL_CONSTANT_ATTENUATION           = $1207;
      GL_LINEAR_ATTENUATION             = $1208;
      GL_QUADRATIC_ATTENUATION          = $1209;

      // InterleavedArrays
      //      GL_V2F
      //      GL_V3F
      //      GL_C4UB_V2F
      //      GL_C4UB_V3F
      //      GL_C3F_V3F
      //      GL_N3F_V3F
      //      GL_C4F_N3F_V3F
      //      GL_T2F_V3F
      //      GL_T4F_V4F
      //      GL_T2F_C4UB_V3F
      //      GL_T2F_C3F_V3F
      //      GL_T2F_N3F_V3F
      //      GL_T2F_C4F_N3F_V3F
      //      GL_T4F_C4F_N3F_V4F

      // ListMode
      GL_COMPILE                        = $1300;
      GL_COMPILE_AND_EXECUTE            = $1301;

      // ListNameType
      //      GL_BYTE
      //      GL_UNSIGNED_BYTE
      //      GL_SHORT
      //      GL_UNSIGNED_SHORT
      //      GL_INT
      //      GL_UNSIGNED_INT
      //      GL_FLOAT
      //      GL_2_BYTES
      //      GL_3_BYTES
      //      GL_4_BYTES

      // LogicOp
      GL_CLEAR                          = $1500;
      GL_AND                            = $1501;
      GL_AND_REVERSE                    = $1502;
      GL_COPY                           = $1503;
      GL_AND_INVERTED                   = $1504;
      GL_NOOP                           = $1505;
      GL_XOR                            = $1506;
      GL_OR                             = $1507;
      GL_NOR                            = $1508;
      GL_EQUIV                          = $1509;
      GL_INVERT                         = $150A;
      GL_OR_REVERSE                     = $150B;
      GL_COPY_INVERTED                  = $150C;
      GL_OR_INVERTED                    = $150D;
      GL_NAND                           = $150E;
      GL_SET                            = $150F;

      // MapTarget
      //      GL_MAP1_COLOR_4
      //      GL_MAP1_INDEX
      //      GL_MAP1_NORMAL
      //      GL_MAP1_TEXTURE_COORD_1
      //      GL_MAP1_TEXTURE_COORD_2
      //      GL_MAP1_TEXTURE_COORD_3
      //      GL_MAP1_TEXTURE_COORD_4
      //      GL_MAP1_VERTEX_3
      //      GL_MAP1_VERTEX_4
      //      GL_MAP2_COLOR_4
      //      GL_MAP2_INDEX
      //      GL_MAP2_NORMAL
      //      GL_MAP2_TEXTURE_COORD_1
      //      GL_MAP2_TEXTURE_COORD_2
      //      GL_MAP2_TEXTURE_COORD_3
      //      GL_MAP2_TEXTURE_COORD_4
      //      GL_MAP2_VERTEX_3
      //      GL_MAP2_VERTEX_4

      // MaterialFace
      //      GL_FRONT
      //      GL_BACK
      //      GL_FRONT_AND_BACK

      // MaterialParameter
      GL_EMISSION                       = $1600;
      GL_SHININESS                      = $1601;
      GL_AMBIENT_AND_DIFFUSE            = $1602;
      GL_COLOR_INDEXES                  = $1603;
      //      GL_AMBIENT
      //      GL_DIFFUSE
      //      GL_SPECULAR

      // MatrixMode
      GL_MODELVIEW                      = $1700;
      GL_PROJECTION                     = $1701;
      GL_TEXTURE                        = $1702;

      // MeshMode1
      //      GL_POINT
      //      GL_LINE

      // MeshMode2 
      //      GL_POINT 
      //      GL_LINE 
      //      GL_FILL 

      // NormalPointerType 
      //      GL_BYTE 
      //      GL_SHORT
      //      GL_INT 
      //      GL_FLOAT 
      //      GL_DOUBLE 

      // PixelCopyType
      GL_COLOR                          = $1800;
      GL_DEPTH                          = $1801;
      GL_STENCIL                        = $1802;

      // PixelFormat
      GL_COLOR_INDEX                    = $1900;
      GL_STENCIL_INDEX                  = $1901;
      GL_DEPTH_COMPONENT                = $1902;
      GL_RED                            = $1903;
      GL_GREEN                          = $1904;
      GL_BLUE                           = $1905;
      GL_ALPHA                          = $1906;
      GL_RGB                            = $1907;
      GL_RGBA                           = $1908;
      GL_LUMINANCE                      = $1909;
      GL_LUMINANCE_ALPHA                = $190A;

      // PixelMap
      //      GL_PIXEL_MAP_I_TO_I
      //      GL_PIXEL_MAP_S_TO_S
      //      GL_PIXEL_MAP_I_TO_R
      //      GL_PIXEL_MAP_I_TO_G
      //      GL_PIXEL_MAP_I_TO_B 
      //      GL_PIXEL_MAP_I_TO_A 
      //      GL_PIXEL_MAP_R_TO_R 
      //      GL_PIXEL_MAP_G_TO_G 
      //      GL_PIXEL_MAP_B_TO_B 
      //      GL_PIXEL_MAP_A_TO_A

      // PixelStore 
      //      GL_UNPACK_SWAP_BYTES 
      //      GL_UNPACK_LSB_FIRST 
      //      GL_UNPACK_ROW_LENGTH 
      //      GL_UNPACK_SKIP_ROWS 
      //      GL_UNPACK_SKIP_PIXELS
      //      GL_UNPACK_ALIGNMENT 
      //      GL_PACK_SWAP_BYTES 
      //      GL_PACK_LSB_FIRST 
      //      GL_PACK_ROW_LENGTH 
      //      GL_PACK_SKIP_ROWS 
      //      GL_PACK_SKIP_PIXELS 
      //      GL_PACK_ALIGNMENT 

      // PixelTransfer 
      //      GL_MAP_COLOR 
      //      GL_MAP_STENCIL 
      //      GL_INDEX_SHIFT 
      //      GL_INDEX_OFFSET 
      //      GL_RED_SCALE 
      //      GL_RED_BIAS 
      //      GL_GREEN_SCALE
      //      GL_GREEN_BIAS
      //      GL_BLUE_SCALE 
      //      GL_BLUE_BIAS 
      //      GL_ALPHA_SCALE 
      //      GL_ALPHA_BIAS 
      //      GL_DEPTH_SCALE 
      //      GL_DEPTH_BIAS 

      // PixelType
      GL_BITMAP                         = $1A00;
      //      GL_BYTE
      //      GL_UNSIGNED_BYTE
      //      GL_SHORT
      //      GL_UNSIGNED_SHORT
      //      GL_INT
      //      GL_UNSIGNED_INT
      //      GL_FLOAT

      // PolygonMode
      GL_POINT                          = $1B00;
      GL_LINE                           = $1B01;
      GL_FILL                           = $1B02;

      // ReadBufferMode
      //      GL_FRONT_LEFT
      //      GL_FRONT_RIGHT
      //      GL_BACK_LEFT
      //      GL_BACK_RIGHT
      //      GL_FRONT
      //      GL_BACK
      //      GL_LEFT
      //      GL_RIGHT
      //      GL_AUX0
      //      GL_AUX1
      //      GL_AUX2
      //      GL_AUX3

      // RenderingMode
      GL_RENDER                         = $1C00;
      GL_FEEDBACK                       = $1C01;
      GL_SELECT                         = $1C02;

      // ShadingModel
      GL_FLAT                           = $1D00;
      GL_SMOOTH                         = $1D01;

      // StencilFunction
      //      GL_NEVER
      //      GL_LESS
      //      GL_EQUAL
      //      GL_LEQUAL
      //      GL_GREATER
      //      GL_NOTEQUAL
      //      GL_GEQUAL
      //      GL_ALWAYS

      // StencilOp
      //      GL_ZERO
      GL_KEEP                           = $1E00;
      GL_REPLACE                        = $1E01;
      GL_INCR                           = $1E02;
      GL_DECR                           = $1E03;
      //      GL_INVERT

      // StringName
      GL_VENDOR                         = $1F00;
      GL_RENDERER                       = $1F01;
      GL_VERSION                        = $1F02;
      GL_EXTENSIONS                     = $1F03;

      // TextureCoordName
      GL_S                              = $2000;
      GL_T                              = $2001;
      GL_R                              = $2002;
      GL_Q                              = $2003;

      // TexCoordPointerType
      //      GL_SHORT
      //      GL_INT
      //      GL_FLOAT
      //      GL_DOUBLE

     // TextureEnvMode
      GL_MODULATE                       = $2100;
      GL_DECAL                          = $2101;
      //      GL_BLEND
      //      GL_REPLACE

      // TextureEnvParameter
      GL_TEXTURE_ENV_MODE               = $2200;
      GL_TEXTURE_ENV_COLOR              = $2201;

      // TextureEnvTarget
      GL_TEXTURE_ENV                    = $2300;

      // TextureGenMode
      GL_EYE_LINEAR                     = $2400;
      GL_OBJECT_LINEAR                  = $2401;
      GL_SPHERE_MAP                     = $2402;

      // TextureGenParameter
      GL_TEXTURE_GEN_MODE               = $2500;
      GL_OBJECT_PLANE                   = $2501;
      GL_EYE_PLANE                      = $2502;

      // TextureMagFilter
      GL_NEAREST                        = $2600;
      GL_LINEAR                         = $2601;

      // TextureMinFilter
      //      GL_NEAREST
      //      GL_LINEAR
      GL_NEAREST_MIPMAP_NEAREST         = $2700;
      GL_LINEAR_MIPMAP_NEAREST          = $2701;
      GL_NEAREST_MIPMAP_LINEAR          = $2702;
      GL_LINEAR_MIPMAP_LINEAR           = $2703;

      // TextureParameterName
      GL_TEXTURE_MAG_FILTER             = $2800;
      GL_TEXTURE_MIN_FILTER             = $2801;
      GL_TEXTURE_WRAP_S                 = $2802;
      GL_TEXTURE_WRAP_T                 = $2803;
      //      GL_TEXTURE_BORDER_COLOR
      //      GL_TEXTURE_PRIORITY

      // TextureTarget
      //      GL_TEXTURE_1D
      //      GL_TEXTURE_2D
      //      GL_PROXY_TEXTURE_1D
      //      GL_PROXY_TEXTURE_2D

      // TextureWrapMode
      GL_CLAMP                          = $2900;
      GL_REPEAT                         = $2901;
      GL_CLAMP_TO_EDGE                  = $812F;

      // VertexPointerType
      //      GL_SHORT
      //      GL_INT
      //      GL_FLOAT
      //      GL_DOUBLE

      // ClientAttribMask
      GL_CLIENT_PIXEL_STORE_BIT         = $00000001;
      GL_CLIENT_VERTEX_ARRAY_BIT        = $00000002;
      GL_CLIENT_ALL_ATTRIB_BITS         = $ffffffff;

      // polygon_offset
      GL_POLYGON_OFFSET_FACTOR          = $8038;
      GL_POLYGON_OFFSET_UNITS           = $2A00;
      GL_POLYGON_OFFSET_POINT           = $2A01;
      GL_POLYGON_OFFSET_LINE            = $2A02;
      GL_POLYGON_OFFSET_FILL            = $8037;

      // texture
      GL_ALPHA4                         = $803B;
      GL_ALPHA8                         = $803C;
      GL_ALPHA12                        = $803D;
      GL_ALPHA16                        = $803E;
      GL_LUMINANCE4                     = $803F;
      GL_LUMINANCE8                     = $8040;
      GL_LUMINANCE12                    = $8041;
      GL_LUMINANCE16                    = $8042;
      GL_LUMINANCE4_ALPHA4              = $8043;
      GL_LUMINANCE6_ALPHA2              = $8044;
      GL_LUMINANCE8_ALPHA8              = $8045;
      GL_LUMINANCE12_ALPHA4             = $8046;
      GL_LUMINANCE12_ALPHA12            = $8047;
      GL_LUMINANCE16_ALPHA16            = $8048;
      GL_INTENSITY                      = $8049;
      GL_INTENSITY4                     = $804A;
      GL_INTENSITY8                     = $804B;
      GL_INTENSITY12                    = $804C;
      GL_INTENSITY16                    = $804D;
      GL_R3_G3_B2                       = $2A10;
      GL_RGB4                           = $804F;
      GL_RGB5                           = $8050;
      GL_RGB8                           = $8051;
      GL_RGB10                          = $8052;
      GL_RGB12                          = $8053;
      GL_RGB16                          = $8054;
      GL_RGBA2                          = $8055;
      GL_RGBA4                          = $8056;
      GL_RGB5_A1                        = $8057;
      GL_RGBA8                          = $8058;
      GL_RGB10_A2                       = $8059;
      GL_RGBA12                         = $805A;
      GL_RGBA16                         = $805B;
      GL_TEXTURE_RED_SIZE               = $805C;
      GL_TEXTURE_GREEN_SIZE             = $805D;
      GL_TEXTURE_BLUE_SIZE              = $805E;
      GL_TEXTURE_ALPHA_SIZE             = $805F;
      GL_TEXTURE_LUMINANCE_SIZE         = $8060;
      GL_TEXTURE_INTENSITY_SIZE         = $8061;
      GL_PROXY_TEXTURE_1D               = $8063;
      GL_PROXY_TEXTURE_2D               = $8064;

      // texture_object
      GL_TEXTURE_PRIORITY               = $8066;
      GL_TEXTURE_RESIDENT               = $8067;
      GL_TEXTURE_BINDING_1D             = $8068;
      GL_TEXTURE_BINDING_2D             = $8069;

      // vertex_array
      GL_VERTEX_ARRAY                   = $8074;
      GL_NORMAL_ARRAY                   = $8075;
      GL_COLOR_ARRAY                    = $8076;
      GL_INDEX_ARRAY                    = $8077;
      GL_TEXTURE_COORD_ARRAY            = $8078;
      GL_EDGE_FLAG_ARRAY                = $8079;
      GL_VERTEX_ARRAY_SIZE              = $807A;
      GL_VERTEX_ARRAY_TYPE              = $807B;
      GL_VERTEX_ARRAY_STRIDE            = $807C;
      GL_NORMAL_ARRAY_TYPE              = $807E;
      GL_NORMAL_ARRAY_STRIDE            = $807F;
      GL_COLOR_ARRAY_SIZE               = $8081;
      GL_COLOR_ARRAY_TYPE               = $8082;
      GL_COLOR_ARRAY_STRIDE             = $8083;
      GL_INDEX_ARRAY_TYPE               = $8085;
      GL_INDEX_ARRAY_STRIDE             = $8086;
      GL_TEXTURE_COORD_ARRAY_SIZE       = $8088;
      GL_TEXTURE_COORD_ARRAY_TYPE       = $8089;
      GL_TEXTURE_COORD_ARRAY_STRIDE     = $808A;
      GL_EDGE_FLAG_ARRAY_STRIDE         = $808C;
      GL_VERTEX_ARRAY_POINTER           = $808E;
      GL_NORMAL_ARRAY_POINTER           = $808F;
      GL_COLOR_ARRAY_POINTER            = $8090;
      GL_INDEX_ARRAY_POINTER            = $8091;
      GL_TEXTURE_COORD_ARRAY_POINTER    = $8092;
      GL_EDGE_FLAG_ARRAY_POINTER        = $8093;
      GL_V2F                            = $2A20;
      GL_V3F                            = $2A21;
      GL_C4UB_V2F                       = $2A22;
      GL_C4UB_V3F                       = $2A23;
      GL_C3F_V3F                        = $2A24;
      GL_N3F_V3F                        = $2A25;
      GL_C4F_N3F_V3F                    = $2A26;
      GL_T2F_V3F                        = $2A27;
      GL_T4F_V4F                        = $2A28;
      GL_T2F_C4UB_V3F                   = $2A29;
      GL_T2F_C3F_V3F                    = $2A2A;
      GL_T2F_N3F_V3F                    = $2A2B;
      GL_T2F_C4F_N3F_V3F                = $2A2C;
      GL_T4F_C4F_N3F_V4F                = $2A2D;

      // Extensions
      GL_EXT_vertex_array               = 1;
      GL_WIN_swap_hint                  = 1;
      GL_EXT_bgra                       = 1;
      GL_EXT_paletted_texture           = 1;

      // EXT_vertex_array
      GL_VERTEX_ARRAY_EXT               = $8074;
      GL_NORMAL_ARRAY_EXT               = $8075;
      GL_COLOR_ARRAY_EXT                = $8076;
      GL_INDEX_ARRAY_EXT                = $8077;
      GL_TEXTURE_COORD_ARRAY_EXT        = $8078;
      GL_EDGE_FLAG_ARRAY_EXT            = $8079;
      GL_VERTEX_ARRAY_SIZE_EXT          = $807A;
      GL_VERTEX_ARRAY_TYPE_EXT          = $807B;
      GL_VERTEX_ARRAY_STRIDE_EXT        = $807C;
      GL_VERTEX_ARRAY_COUNT_EXT         = $807D;
      GL_NORMAL_ARRAY_TYPE_EXT          = $807E;
      GL_NORMAL_ARRAY_STRIDE_EXT        = $807F;
      GL_NORMAL_ARRAY_COUNT_EXT         = $8080;
      GL_COLOR_ARRAY_SIZE_EXT           = $8081;
      GL_COLOR_ARRAY_TYPE_EXT           = $8082;
      GL_COLOR_ARRAY_STRIDE_EXT         = $8083;
      GL_COLOR_ARRAY_COUNT_EXT          = $8084;
      GL_INDEX_ARRAY_TYPE_EXT           = $8085;
      GL_INDEX_ARRAY_STRIDE_EXT         = $8086;
      GL_INDEX_ARRAY_COUNT_EXT          = $8087;
      GL_TEXTURE_COORD_ARRAY_SIZE_EXT   = $8088;
      GL_TEXTURE_COORD_ARRAY_TYPE_EXT   = $8089;
      GL_TEXTURE_COORD_ARRAY_STRIDE_EXT = $808A;
      GL_TEXTURE_COORD_ARRAY_COUNT_EXT  = $808B;
      GL_EDGE_FLAG_ARRAY_STRIDE_EXT     = $808C;
      GL_EDGE_FLAG_ARRAY_COUNT_EXT      = $808D;
      GL_VERTEX_ARRAY_POINTER_EXT       = $808E;
      GL_NORMAL_ARRAY_POINTER_EXT       = $808F;
      GL_COLOR_ARRAY_POINTER_EXT        = $8090;
      GL_INDEX_ARRAY_POINTER_EXT        = $8091;
      GL_TEXTURE_COORD_ARRAY_POINTER_EXT = $8092;
      GL_EDGE_FLAG_ARRAY_POINTER_EXT    = $8093;
      GL_DOUBLE_EXT                     = GL_DOUBLE;

      // EXT_bgra
      GL_BGR_EXT                        = $80E0;
      GL_BGRA_EXT                       = $80E1;

      // EXT_paletted_texture
      // These must match the GL_COLOR_TABLE_*_SGI enumerants
      GL_COLOR_TABLE_FORMAT_EXT         = $80D8;
      GL_COLOR_TABLE_WIDTH_EXT          = $80D9;
      GL_COLOR_TABLE_RED_SIZE_EXT       = $80DA;
      GL_COLOR_TABLE_GREEN_SIZE_EXT     = $80DB;
      GL_COLOR_TABLE_BLUE_SIZE_EXT      = $80DC;
      GL_COLOR_TABLE_ALPHA_SIZE_EXT     = $80DD;
      GL_COLOR_TABLE_LUMINANCE_SIZE_EXT = $80DE;
      GL_COLOR_TABLE_INTENSITY_SIZE_EXT = $80DF;

      GL_COLOR_INDEX1_EXT               = $80E2;
      GL_COLOR_INDEX2_EXT               = $80E3;
      GL_COLOR_INDEX4_EXT               = $80E4;
      GL_COLOR_INDEX8_EXT               = $80E5;
      GL_COLOR_INDEX12_EXT              = $80E6;
      GL_COLOR_INDEX16_EXT              = $80E7;

      // For compatibility with OpenGL v1.0
      GL_LOGIC_OP                       = GL_INDEX_LOGIC_OP;
      GL_TEXTURE_COMPONENTS             = GL_TEXTURE_INTERNAL_FORMAT;

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  OpenGL32 ='OpenGL32.DLL';

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

PROCEDURE glAccum(op: GLuint; value: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glAlphaFunc(func: GLenum; ref: GLclampf); STDCALL; EXTERNAL OpenGL32;
FUNCTION  glAreTexturesResident(n: GLsizei; CONST textures: PGLuint; residences: PGLboolean): GLboolean;
                                STDCALL; EXTERNAL OpenGL32;
PROCEDURE glArrayElement(i: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glBegin(mode: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glBindTexture(target: GLenum; texture: GLuint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glBitmap(width: GLsizei; height: GLsizei; xorig, yorig: GLfloat; xmove: GLfloat; ymove: GLfloat;
                   CONST bitmap: PGLubyte); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glBlendFunc(sfactor: GLenum; dfactor: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glCallList(list: GLuint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glCallLists(n: GLsizei; atype: GLenum; CONST lists); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glClear(mask: GLbitfield); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glClearAccum(red, green, blue, alpha: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glClearColor(red, green, blue, alpha: GLclampf); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glClearDepth(depth: GLclampd); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glClearIndex(c: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glClearStencil(s: GLint ); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glClipPlane(plane: GLenum; CONST equation: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor3b(red, green, blue: GLbyte); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor3bv(CONST v: PGLbyte); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor3d(red, green, blue: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor3dv(CONST v: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor3f(red, green, blue: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor3fv(CONST v: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor3i(red, green, blue: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor3iv(CONST v: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor3s(red, green, blue: GLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor3sv(CONST v: PGLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor3ub(red, green, blue: GLubyte); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor3ubv(CONST v: PGLubyte); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor3ui(red, green, blue: GLuint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor3uiv(CONST v: PGLuint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor3us(red, green, blue: GLushort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor3usv(CONST v: PGLushort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor4b(red, green, blue, alpha: GLbyte); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor4bv(CONST v: PGLbyte); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor4d(red, green, blue, alpha: GLdouble ); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor4dv(CONST v: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor4f(red, green, blue, alpha: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor4fv(CONST v: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor4i(red, green, blue, alpha: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor4iv(CONST v: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor4s(red, green, blue, alpha: GLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor4sv(CONST v: GLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor4ub(red, green, blue, alpha: GLubyte); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor4ubv(CONST v: PGLubyte); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor4ui(red, green, blue, alpha: GLuint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor4uiv(CONST v: PGLuint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor4us(red, green, blue, alpha: GLushort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColor4usv(CONST v: PGLushort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColorMask(red, green, blue, alpha: GLboolean); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColorMaterial(face: GLenum; mode: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glColorPointer(size: GLint; atype: GLenum; stride: GLsizei; CONST pointer); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glCopyPixels(x, y: GLint; width, height: GLsizei; atype: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glCopyTexImage1D(target: GLenum; level: GLint; internalFormat: GLenum; x, y: GLint; width: GLsizei;
                           border: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glCopyTexImage2D(target: GLenum; level: GLint; internalFormat: GLenum; x, y: GLint;
                           width, height: GLsizei; border: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glCopyTexSubImage1D(target: GLenum; level, xoffset, x, y: GLint; width: GLsizei); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glCopyTexSubImage2D(target: GLenum; level, xoffset, yoffset, x, y: GLint;
                              width, height: GLsizei); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glCullFace(mode: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glDeleteLists(list: GLuint; range: GLsizei); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glDeleteTextures(n: GLsizei; CONST textures: PGLuint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glDepthFunc(func: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glDepthMask(flag: GLboolean); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glDepthRange(zNear, zFar: GLclampd); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glDisable(cap: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glDisableClientState(aarray: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glDrawArrays(mode: GLenum; first: GLint; count: GLsizei); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glDrawBuffer(mode: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glDrawElements(mode: GLenum; count: GLsizei; atype: GLenum; CONST indices); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glDrawPixels(width, height: GLsizei; format, atype: GLenum; CONST pixels); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEdgeFlag(flag: GLboolean); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEdgeFlagPointer(stride: GLsizei; CONST pointer); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEdgeFlagv(CONST flag: PGLboolean); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEnable(cap: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEnableClientState(aarray: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEnd; STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEndList; STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEvalCoord1d(u: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEvalCoord1dv(CONST u: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEvalCoord1f(u: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEvalCoord1fv(CONST u: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEvalCoord2d(u: GLdouble; v: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEvalCoord2dv(CONST u: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEvalCoord2f(u, v: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEvalCoord2fv(CONST u: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEvalMesh1(mode: GLenum; i1, i2: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEvalMesh2(mode: GLenum; i1, i2, j1, j2: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEvalPoint1(i: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glEvalPoint2(i, j: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glFeedbackBuffer(size: GLsizei; atype: GLenum; buffer: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glFinish; STDCALL; EXTERNAL OpenGL32;
PROCEDURE glFlush; STDCALL; EXTERNAL OpenGL32;
PROCEDURE glFogf(pname: GLenum; param: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glFogfv(pname: GLenum; CONST params: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glFogi(pname: GLenum; param: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glFogiv(pname: GLenum; CONST params: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glFrontFace(mode: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glFrustum(left, right, bottom, top, zNear, zFar: GLdouble); STDCALL; EXTERNAL OpenGL32;
FUNCTION  glGenLists(range: GLsizei): GLuint; STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGenTextures(n: GLsizei; textures: PGLuint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetBooleanv(pname: GLenum; params: PGLboolean); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetClipPlane(plane: GLenum; equation: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetDoublev(pname: GLenum; params: PGLdouble); STDCALL; EXTERNAL OpenGL32;
FUNCTION  glGetError: GLuint; STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetFloatv(pname: GLenum; params: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetIntegerv(pname: GLenum; params: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetLightfv(light, pname: GLenum; params: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetLightiv(light, pname: GLenum; params: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetMapdv(target, query: GLenum; v: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetMapfv(target, query: GLenum; v: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetMapiv(target, query: GLenum; v: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetMaterialfv(face, pname: GLenum; params: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetMaterialiv(face, pname: GLenum; params: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetPixelMapfv(map: GLenum; values: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetPixelMapuiv(map: GLenum; values: PGLuint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetPixelMapusv(map: GLenum; values: PGLushort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetPointerv(pname: GLenum; VAR params: Pointer); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetPolygonStipple(mask: PGLubyte); STDCALL; EXTERNAL OpenGL32;
FUNCTION  glGetString(name: GLenum): PGLubyte; STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetTexEnvfv(target, pname: GLenum; params: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetTexEnviv(target, pname: GLenum; params: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetTexGendv(coord, pname: GLenum; params: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetTexGenfv(coord, pname: GLenum; params: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetTexGeniv(coord, pname: GLenum; params: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetTexImage(target: GLenum; level: GLint; format, atype: GLenum; pixels: Pointer); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetTexLevelParameterfv(target: GLenum; level: GLint; pname: GLenum; params: PGLfloat);
                                   STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetTexLevelParameteriv(target: GLenum; level: GLint; pname: GLenum; params: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetTexParameterfv(target, pname: GLenum; params: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glGetTexParameteriv(target, pname: GLenum; params: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glHint(target, mode: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glIndexMask(mask: GLuint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glIndexPointer(atype: GLenum; stride: GLsizei; CONST pointer); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glIndexd(c: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glIndexdv(CONST c: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glIndexf(c: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glIndexfv(CONST c: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glIndexi(c: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glIndexiv(CONST c: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glIndexs(c: GLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glIndexsv(CONST c: PGLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glIndexub(c: GLubyte); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glIndexubv(CONST c: PGLubyte); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glInitNames; STDCALL; EXTERNAL OpenGL32;
PROCEDURE glInterleavedArrays(format: GLenum; stride: GLsizei; CONST pointer); STDCALL; EXTERNAL OpenGL32;
FUNCTION  glIsEnabled(cap: GLenum): GLboolean; STDCALL; EXTERNAL OpenGL32;
FUNCTION  glIsList(list: GLuint): GLboolean; STDCALL; EXTERNAL OpenGL32;
FUNCTION  glIsTexture(texture: GLuint): GLboolean; STDCALL; EXTERNAL OpenGL32;
PROCEDURE glLightModelf(pname: GLenum; param: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glLightModelfv(pname: GLenum; CONST params: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glLightModeli(pname: GLenum; param: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glLightModeliv(pname: GLenum; CONST params: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glLightf(light, pname: GLenum; param: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glLightfv(light, pname: GLenum; CONST params: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glLighti(light, pname: GLenum; param: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glLightiv(light, pname: GLenum; CONST params: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glLineStipple(factor: GLint; pattern: GLushort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glLineWidth(width: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glListBase(base: GLuint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glLoadIdentity; STDCALL; EXTERNAL OpenGL32;
PROCEDURE glLoadMatrixd(CONST m: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glLoadMatrixf(CONST m: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glLoadName(name: GLuint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glLogicOp(opcode: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glMap1d(target: GLenum; u1, u2: GLdouble; stride, order: GLint; CONST points: PGLdouble);
                  STDCALL; EXTERNAL OpenGL32;
PROCEDURE glMap1f(target: GLenum; u1, u2: GLfloat; stride, order: GLint; CONST points: PGLfloat);
                  STDCALL; EXTERNAL OpenGL32;
PROCEDURE glMap2d(target: GLenum; u1, u2: GLdouble; ustride, uorder: GLint; v1, v2: GLdouble;
                  vstride, vorder: GLint; CONST points: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glMap2f(target: GLenum; u1, u2: GLfloat; ustride, uorder: GLint; v1, v2: GLfloat;
                  vstride, vorder: GLint; CONST points: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glMapGrid1d(un: GLint; u1, u2: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glMapGrid1f(un: GLint; u1, u2: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glMapGrid2d(un: GLint; u1, u2: GLdouble; vn: GLint; v1, v2: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glMapGrid2f(un: GLint; u1, u2: GLfloat; vn: GLint; v1, v2: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glMaterialf(face, pname: GLenum; param: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glMaterialfv(face, pname: GLenum; CONST params: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glMateriali(face, pname: GLenum; param: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glMaterialiv(face, pname: GLenum; CONST params: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glMatrixMode(mode: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glMultMatrixd(CONST m: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glMultMatrixf(CONST m: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glNewList(list: GLuint; mode: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glNormal3b(nx, ny, nz: GLbyte); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glNormal3bv(CONST v: PGLbyte); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glNormal3d(nx, ny, nz: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glNormal3dv(CONST v: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glNormal3f(nx, ny, nz: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glNormal3fv(CONST v: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glNormal3i(nx, ny, nz: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glNormal3iv(CONST v: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glNormal3s(nx, ny, nz: GLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glNormal3sv(CONST v: PGLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glNormalPointer(atype: GLenum; stride: GLsizei; CONST pointer); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glOrtho(left, right, bottom, top, zNear, zFar: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPassThrough(token: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPixelMapfv(map: GLenum; mapsize: GLsizei; CONST values: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPixelMapuiv(map: GLenum; mapsize: GLsizei; CONST values: PGLuint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPixelMapusv(map: GLenum; mapsize: GLsizei; CONST values: PGLushort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPixelStoref(pname: GLenum; param: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPixelStorei(pname: GLenum; param: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPixelTransferf(pname: GLenum; param: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPixelTransferi(pname: GLenum; param: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPixelZoom(xfactor, yfactor: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPointSize(size: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPolygonMode(face, mode: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPolygonOffset(factor, units: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPolygonStipple(CONST mask: PGLubyte); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPopAttrib; STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPopClientAttrib; STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPopMatrix; STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPopName; STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPrioritizeTextures(n: GLsizei; CONST textures: PGLuint; CONST priorities: PGLclampf); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPushAttrib(mask: GLbitfield); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPushClientAttrib(mask: GLbitfield); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPushMatrix; STDCALL; EXTERNAL OpenGL32;
PROCEDURE glPushName(name: GLuint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos2d(x, y: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos2dv(CONST v: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos2f(x, y: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos2fv(CONST v: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos2i(x, y: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos2iv(CONST v: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos2s(x, y: PGLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos2sv(CONST v: PGLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos3d(x, y, z: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos3dv(CONST v: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos3f(x, y, z: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos3fv(CONST v: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos3i(x, y, z: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos3iv(CONST v: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos3s(x, y, z: GLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos3sv(CONST v: PGLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos4d(x, y, z, w: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos4dv(CONST v: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos4f(x, y, z, w: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos4fv(CONST v: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos4i(x, y, z, w: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos4iv(CONST v: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos4s(x, y, z, w: GLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRasterPos4sv(CONST v: PGLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glReadBuffer(mode: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glReadPixels(x, y: GLint; width, height: GLsizei; format, atype: GLenum; pixels: Pointer);
                       STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRectd(x1, y1, x2, y2: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRectdv(CONST v1, v2: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRectf(x1, y1, x2, y2: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRectfv(CONST v1, v2: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRecti(x1, y1, x2, y2: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRectiv(CONST v1, v2: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRects(x1, y1, x2, y2: GLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRectsv(CONST v1, v2: PGLshort); STDCALL; EXTERNAL OpenGL32;
FUNCTION  glRenderMode(mode: GLenum): GLint; STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRotated(angle, x, y, z: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glRotatef(angle, x, y, z: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glScaled(x, y, z: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glScalef(x, y, z: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glScissor(x, y: GLint; width, height: GLsizei); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glSelectBuffer(size: GLsizei; buffer: PGLuint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glShadeModel(mode: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glStencilFunc(func: GLenum; ref: GLint; mask: GLuint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glStencilMask(mask: GLuint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glStencilOp(fail, zfail, zpass: GLenum); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord1d(s: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord1dv(CONST v: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord1f(s: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord1fv(CONST v: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord1i(s: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord1iv(CONST v: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord1s(s: GLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord1sv(CONST v: PGLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord2d(s, t: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord2dv(CONST v: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord2f(s, t: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord2fv(CONST v: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord2i(s, t: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord2iv(CONST v: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord2s(s, t: GLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord2sv(CONST v: PGLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord3d(s, t, r: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord3dv(CONST v: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord3f(s, t, r: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord3fv(CONST v: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord3i(s, t, r: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord3iv(CONST v: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord3s(s, t, r: GLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord3sv(CONST v: PGLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord4d(s, t, r, q: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord4dv(CONST v: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord4f(s, t, r, q: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord4fv(CONST v: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord4i(s, t, r, q: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord4iv(CONST v: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord4s(s, t, r, q: GLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoord4sv(CONST v: PGLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexCoordPointer(size: GLint; atype: GLenum; stride: GLsizei; CONST pointer);
                            STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexEnvf(target, pname: GLenum; param: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexEnvfv(target, pname: GLenum; CONST params: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexEnvi(target, pname: GLenum; param: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexEnviv(target, pname: GLenum; CONST params: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexGend(coord, pname: GLenum; param: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexGendv(coord, pname: GLenum; CONST params: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexGenf(coord, pname: GLenum; param: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexGenfv(coord, pname: GLenum; CONST params: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexGeni(coord, pname: GLenum; param: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexGeniv(coord, pname: GLenum; CONST params: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexImage1D(target: GLenum; level, internalformat: GLint; width: GLsizei;
                       border: GLint; format, atype: GLenum; CONST pixels); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexImage2D(target: GLenum; level, internalformat: GLint; width, height: GLsizei;
                       border: GLint; format, atype: GLenum; CONST pixels); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexParameterf(target, pname: GLenum; param: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexParameterfv(target, pname: GLenum; CONST params: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexParameteri(target, pname: GLenum; param: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexParameteriv(target, pname: GLenum; CONST params: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexSubImage1D(target: GLenum; level, xoffset: GLint; width: GLsizei; format, atype: GLenum; CONST pixels);
                          STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTexSubImage2D(target: GLenum; level, xoffset, yoffset: GLint; width, height: GLsizei; format, atype:
                          GLenum; CONST pixels); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTranslated(x, y, z: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glTranslatef(x, y, z: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex2d(x, y: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex2dv(CONST v: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex2f(x, y: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex2fv(CONST v: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex2i(x, y: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex2iv(CONST v: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex2s(x, y: GLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex2sv(CONST v: PGLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex3d(x, y, z: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex3dv(CONST v: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex3f(x, y, z: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex3fv(CONST v: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex3i(x, y, z: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex3iv(CONST v: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex3s(x, y, z: GLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex3sv(CONST v: PGLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex4d(x, y, z, w: GLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex4dv(CONST v: PGLdouble); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex4f(x, y, z, w: GLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex4fv(CONST v: PGLfloat); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex4i(x, y, z, w: GLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex4iv(CONST v: PGLint); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex4s(x, y, z, w: GLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertex4sv(CONST v: PGLshort); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glVertexPointer(size: GLint; atype: GLenum; stride: GLsizei; CONST pointer); STDCALL; EXTERNAL OpenGL32;
PROCEDURE glViewport(x, y: GLint; width, height: GLsizei); STDCALL; EXTERNAL OpenGL32;

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

// Windows related functions, most of them are not defined in Windows.pas,
// but should be there (Delphi 2.0)
//wglChoosePixelFormat
//wglCopyContext
FUNCTION wglCreateContext(hdc: HDC): HGLRC; STDCALL; EXTERNAL OpenGL32;
//wglCreateLayerContext
FUNCTION wglDeleteContext(hglrc: HGLRC): GLBoolean; STDCALL; EXTERNAL OpenGL32;
//wglDescribeLayerPlane
//wglDescribePixelFormat
FUNCTION wglGetCurrentContext: HGLRC; STDCALL; EXTERNAL OpenGL32;
FUNCTION wglGetCurrentDC: HDC; STDCALL; EXTERNAL OpenGL32;
//wglGetDefaultProcAddress
//wglGetLayerPaletteEntries
//wglGetPixelFormat
FUNCTION wglGetProcAddress(lpszProc: PChar): Pointer; STDCALL; EXTERNAL OpenGL32;
FUNCTION wglMakeCurrent(hdc: HDC; hglrc: HGLRC): GLBoolean; STDCALL; EXTERNAL OpenGL32;
//wglRealizeLayerPalette
//wglSetLayerPaletteEntries
//wglSetPixelFormat
FUNCTION wglShareLists(hglrc1, hglrc2 : HGLRC): GLBoolean; STDCALL; EXTERNAL OpenGL32;
FUNCTION wglSwapBuffers(hdc: HDC): GLBoolean;  STDCALL; EXTERNAL OpenGL32;
//wglSwapLayerBuffers
//wglUseFontBitmapsA
//wglUseFontBitmapsW
//wglUseFontOutlinesA
//wglUseFontOutlinesW

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

TYPE // EXT_vertex_array
     TpfnGLArrayElementExtProc      = PROCEDURE(i: GLint); STDCALL;
     TpfnGLDrawArraysExtProc        = PROCEDURE(mode: GLenum; first: GLint; count: GLsizei); STDCALL;
     TpfnGLVertexPointerExtProc     = PROCEDURE(size: GLint; atype: GLenum; stride, count: GLsizei; CONST pointer); STDCALL;
     TpfnGLNormalPointerExtProc     = PROCEDURE(atype: GLenum; stride, count: GLsizei; CONST pointer); STDCALL;
     TpfnGLColorPointerExtProc      = PROCEDURE(size: GLint; atype: GLenum; stride, count: GLsizei; CONST pointer); STDCALL;
     TpfnGLIndexPointerExtProc      = PROCEDURE(atype: GLenum; stride, count: GLsizei; CONST pointer); STDCALL;
     TpfnGLTexCoordPointerExtProc   = PROCEDURE(size: GLint; atype: GLenum; stride, count: GLsizei; CONST pointer); STDCALL;
     TpfnGLEdgeFlagPointerExtProc   = PROCEDURE(stride, count: GLsizei; CONST pointer: PGLboolean); STDCALL;
     TpfnGLGetPointervExtProc       = PROCEDURE(pname: GLenum; VAR params: Pointer); STDCALL;
     TpfnGLArrayElementArrayExtProc = PROCEDURE(mode: GLenum; count: GLsizei; CONST pi); STDCALL;

     // WIN_swap_hint
     TpfnGLAddSwapHintRectWinProc   = PROCEDURE(x, y: GLint; width, height: GLsizei);

     // EXT_paletted_texture
     TpfnGLColorTableExtProc        = PROCEDURE(target, internalFormat: GLenum; width: GLsizei; format,
                                                atype: GLenum; CONST data); STDCALL;
     TpfnGLColorSubTableExtProc     = PROCEDURE(target: GLenum; start, count: GLsizei; format,
                                                atype: GLenum; CONST data); STDCALL;
     TpfnGLGetColorTableExtProc     = PROCEDURE(target, format, atype: GLenum; VAR data); STDCALL;
     TpfnGLGetColorTablePameterivExtProc =   PROCEDURE(target, pname: GLenum; VAR params); STDCALL;
     TpfnGLGetColorTablePameterfvExtProc =   PROCEDURE(target, pname: GLenum; VAR params); STDCALL;

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

IMPLEMENTATION

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

initialization
  Set8087CW($133F);
finalization
  Set8087CW(Default8087CW);
end.

