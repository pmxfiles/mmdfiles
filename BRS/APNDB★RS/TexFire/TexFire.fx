////////////////////////////////////////////////////////////////////////////////////////////////
//
//  TexFire.fx ver0.0.1 �r���{�[�h�{�e�N�X�`���A�j���̉��G�t�F�N�g
//  �쐬: �j��P
//
////////////////////////////////////////////////////////////////////////////////////////////////
// �����̃p�����[�^��ύX���Ă�������

#define FireSourceTexFile  "FireSource.png" // ���̎�ƂȂ�e�N�X�`���t�@�C����
#define FireColorTexFile   "palette7.png"   // ���Fpallet�e�N�X�`���t�@�C����

//���������������߂�p�����[�^,������M��Ό����ڂ����\����B
float fireDisFactor = 0.14; 
float fireSizeFactor = 4.0;
float fireShakeFactor = 0.4;

float fireRiseFactor = 6.0;     // ���̏㏸�x
float fireRadiateFactor = 1.3;  // ���̊g����x
float fireWvAmpFactor = 1.0;    // ���̍��E�̗h�炬�U��
float fireWvFreqFactor = 2.66;  // ���̍��E�̗h�炬���g��
float firePowAmpFactor = 0.24;  // ���̖��邳�h�炬�U��
float firePowFreqFactor = 5.0; // ���̖��邳�h�炬���g��
float fireTexMoveLimit = 0.01;  // �I�u�W�F�N�g�ړ��ɔ������̗h�炬���E�l(�ړ����傫�������{�[�h����͂ݏo��ꍇ�͂���������������)

int FrameCount = 1; // 1�t���[���̉��e�N�X�`���X�V��(60fps��1, 30fps��2���炢�������x�X�g)

float fireInitScaling = 1.0;  // ���̏����X�P�[��
float fireAveScaling = 1.0;   // ���̕��σX�P�[��(���f�����ŕ����̃X�P�[���ݒ肵���ꍇ�̕��ϒl)

float ElasticFactor = 1000.0; // �{�[���Ǐ]�̒e���x(������1000�ȏ�ɂ���Ɗ��S�Ǐ]�ɂȂ�)
float ResistFactor = 2.0;     // �{�[���Ǐ]�̒�R�x

#define ADD_FLG  1  // 0:����������, 1:���Z����
#define TEX_WORK_SIZE  512 // ���A�j���[�V�����̍�ƃ��C���T�C�Y


// ����Ȃ��l�͂������牺�͂�����Ȃ��ł�

////////////////////////////////////////////////////////////////////////////////////////////////
// �p�����[�^�錾

float4x4 WorldMatrix         : WORLD;
float4x4 ViewMatrix          : VIEW;
float4x4 ViewProjMatrix      : VIEWPROJECTION;
float4x4 WorldViewProjMatrix : WORLDVIEWPROJECTION;

float4x4 WorldViewMatrixInverse : WORLDVIEWINVERSE;
static float3x3 BillboardMatrix = {
    normalize(WorldViewMatrixInverse[0].xyz),
    normalize(WorldViewMatrixInverse[1].xyz),
    normalize(WorldViewMatrixInverse[2].xyz),
};

// �J����Z����]�s��
float2 ViewportSize : VIEWPORTPIXELSIZE;
static float4 WPos = float4(WorldMatrix._41_42_43, 1);
static float4 pos0 = mul( WPos, ViewProjMatrix);
static float4 posY = mul( float4(WPos.x, WPos.y+1, WPos.z, 1), ViewProjMatrix);
static float2 rotVec0 = posY.xy/posY.w - pos0.xy/pos0.w;
static float2 rotVec = normalize( float2(rotVec0.x*ViewportSize.x/ViewportSize.y, rotVec0.y) );
static float3x3 RotMatrix = float3x3( rotVec.y, -rotVec.x, 0,
                                      rotVec.x,  rotVec.y, 0,
                                             0,         0, 1 );
static float3x3 RotMatrixInv = transpose( RotMatrix );
static float3x3 BillboardZRotMatrix = mul( RotMatrix, BillboardMatrix);

// �㉺�J�����A���O���ɂ��k��(�K��)
float3 CameraDirection : DIRECTION < string Object = "Camera"; >;
static float absCosD = abs( dot(float3(0,1,0), -CameraDirection) );
static float yScale = 1.0f - 0.7f*smoothstep(0.7f, 1.0f, absCosD);

float4 MaterialDiffuse : DIFFUSE  < string Object = "Geometry"; >;
float  SpecularPower   : SPECULARPOWER < string Object = "Geometry"; >; // Shininess   0.1

float time : TIME;
float elapsed_time : ELAPSEDTIME;
static float fireShake = fireShakeFactor * FrameCount / (elapsed_time * 60.0f);
static float Dt = (elapsed_time < 0.2f) ? clamp(elapsed_time, 0.001f, 1.0f/15.0f) : 1.0f/30.0f;

int RepertIndex;

float AcsSi : CONTROLOBJECT < string name = "(self)"; string item = "Si"; >;
float AcsTr : CONTROLOBJECT < string name = "(self)"; string item = "Tr"; >;
static float Scaling = AcsSi * 0.1f;

// ��ƃ��C���T�C�Y
#define TEX_WORK_WIDTH  TEX_WORK_SIZE
#define TEX_WORK_HEIGHT TEX_WORK_SIZE

// ���̎�ƂȂ�e�N�X�`��
texture2D ParticleTex <
    string ResourceName = FireSourceTexFile;
>;
sampler ParticleSamp = sampler_state {
    texture = <ParticleTex>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};

// ���Fpallet�e�N�X�`��
texture2D FireColor <
    string ResourceName = FireColorTexFile; 
    int Miplevels = 1;
    >;
sampler2D FireColorSamp = sampler_state {
    texture = <FireColor>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV = CLAMP;
};

// �m�C�Y�e�N�X�`��
texture2D NoiseOne <
    string ResourceName = "NoiseFreq1.png"; 
    int Miplevels = 1;
>;
sampler2D NoiseOneSamp = sampler_state {
    texture = <NoiseOne>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = WRAP;
    AddressV = WRAP;
};

texture2D NoiseTwo <
    string ResourceName = "NoiseFreq2.png"; 
    int Miplevels = 1;
>;
sampler2D NoiseTwoSamp = sampler_state {
    texture = <NoiseTwo>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = WRAP;
    AddressV = WRAP;
};

// ���A�j���[�V������ƃ��C��
texture2D WorkLayer : RENDERCOLORTARGET <
    int Width = TEX_WORK_WIDTH;
    int Height = TEX_WORK_HEIGHT;
    int Miplevels = 1;
    string Format = "A8R8G8B8" ;
>;
sampler2D WorkLayerSamp = sampler_state {
    texture = <WorkLayer>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV = CLAMP;
};
texture WorkLayerDepthBuffer : RenderDepthStencilTarget <
   int Width=TEX_WORK_WIDTH;
   int Height=TEX_WORK_HEIGHT;
    string Format = "D24S8";
>;

// �I�u�W�F�N�g�̍��W�L�^�p
texture WorldCoordTex : RENDERCOLORTARGET
<
   int Width=2;
   int Height=1;
   string Format="A32B32G32R32F";
>;
sampler WorldCoordSmp = sampler_state
{
   Texture = <WorldCoordTex>;
   AddressU  = CLAMP;
   AddressV = CLAMP;
   MinFilter = NONE;
   MagFilter = NONE;
   MipFilter = NONE;
};
texture WorldCoordDepthBuffer : RenderDepthStencilTarget <
   int Width=2;
   int Height=1;
    string Format = "D24S8";
>;
float4 WorldCoordTexArray[2] : TEXTUREVALUE <
   string TextureName = "WorldCoordTex";
>;


// MMD�{����sampler���㏑�����Ȃ����߂̋L�q�ł��B�폜�s�B
sampler MMDSamp0 : register(s0);
sampler MMDSamp1 : register(s1);
sampler MMDSamp2 : register(s2);

///////////////////////////////////////////////////////////////////////////////////////
// ���A�j���[�V�����̕`��

struct VS_OUTPUT {
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

// ���_�V�F�[�_
VS_OUTPUT VS_FireAnimation( float4 Pos : POSITION, float4 Tex : TEXCOORD0 )
{
    VS_OUTPUT Out;

    Out.Pos = Pos;
    Out.Tex = Tex + float2(0.5f/TEX_WORK_WIDTH, 0.5f/TEX_WORK_HEIGHT);

    return Out;
}

// �s�N�Z���V�F�[�_
float4 PS_FireAnimation(float2 Tex: TEXCOORD0, uniform bool flag) : COLOR0
{
    float2 oldTex = Tex;

    // �I�u�W�F�N�g�ړ��ɔ������炵
    float3 wPosNew = WorldCoordTexArray[1].xyz;
    float3 wPosOld = WorldCoordTexArray[0].xyz;
    wPosNew = mul( wPosNew, (float3x3)ViewMatrix );
    wPosOld = mul( wPosOld, (float3x3)ViewMatrix );
    wPosNew = mul( wPosNew, RotMatrixInv );
    wPosOld = mul( wPosOld, RotMatrixInv );
    float2 moveVec = (wPosNew.xy - wPosOld.xy) / (20.0f * fireInitScaling * fireAveScaling * FrameCount * Scaling * Scaling);
    moveVec.y = -moveVec.y;
    if(moveVec.y < 0) moveVec.y *= 0.5f;
    moveVec = clamp(moveVec, -fireTexMoveLimit, fireTexMoveLimit);
    oldTex += moveVec;

    // ���ˏ�ɉ������炷
    moveVec = float2(0.5f, 0.75f) - Tex;
    float radLen = length(moveVec) * 10000.0f;
    moveVec = normalize(moveVec) * fireRadiateFactor / max(radLen, 750.0f);
    oldTex += moveVec;

    // ��ɉ������炷 ���Q�ƈʒu�����ɂ��炷�ƊG�͏�ɂ����
    moveVec = float2( 0.5f/TEX_WORK_WIDTH * fireWvAmpFactor * (abs(frac(fireWvFreqFactor*time)*2.0f - 1.0f) - 0.5f),
                      0.5f/TEX_WORK_HEIGHT * fireRiseFactor * yScale );
    oldTex += moveVec;

    float4 oldCol = tex2D(WorkLayerSamp, oldTex);

    float4 tmp = oldCol;
    if( flag ){
        // ��ƃ��C���ɔR�ĕ���`�� ���O��̉������炵����ɕ`�悷�鎖�ŔR�ĕ����̂́A�����ʒu�ɕ`��ł���B
        tmp = max(oldCol, tex2D(ParticleSamp, Tex));
        tmp *= smoothstep(0.0f, 0.7f, WorldCoordTexArray[1].w);
    }

    // �m�C�Y�̒ǉ�
    float2 noiseTex;
    noiseTex = Tex;
    noiseTex.y += time * fireShake;
    tmp = saturate(tmp - fireDisFactor * tex2D(NoiseOneSamp, noiseTex * fireSizeFactor));

    noiseTex = Tex;
    noiseTex.x += time * fireShake;
    tmp = saturate(tmp - fireDisFactor * 0.5f * tex2D(NoiseTwoSamp, noiseTex * fireSizeFactor));

    return float4(tmp.rgb, 1.0f);
}


////////////////////////////////////////////////////////////////////////////////////////////////
// �I�u�W�F�N�g�̍��W�v�Z

// ���ʂ̒��_�V�F�[�_
VS_OUTPUT WorldCoord_VS(float4 Pos : POSITION, float2 Tex: TEXCOORD)
{
    VS_OUTPUT Out = (VS_OUTPUT)0; 

    Out.Pos = Pos;
    Out.Tex = Tex + float2(0.25f, 0.5f);

    return Out;
}

// 0�t���[���Đ��Ń��Z�b�g
float4 InitWorldCoord_PS(float2 Tex: TEXCOORD0) : COLOR
{
   // �I�u�W�F�N�g�̍��W
   float4 Pos = tex2D(WorldCoordSmp, Tex);
   if( time < 0.001f ){
      Pos = float4(WorldMatrix._41_42_43, 0.0f);
   }
   return Pos;
}

// ���W�X�V
float4 WorldCoord1_PS(float2 Tex: TEXCOORD0) : COLOR
{
   // �I�u�W�F�N�g�̍��W
   float4 Pos0 = WorldCoordTexArray[0];
   float4 Pos1 = WorldCoordTexArray[1];

   // �I�u�W�F�N�g�̑��x
   float3 Vel = ( Pos1.xyz  - Pos0.xyz ) / Dt;

   // ���[���h���W
   float3 WPos = WorldMatrix._41_42_43;

   // �����x�v�Z(�e����+���x��R��)
   float3 Accel = (WPos - Pos1.xyz) * ElasticFactor - Vel * ResistFactor;

   // �V�������W�ɍX�V
   float3 Pos2 = Pos1.xyz + Dt * (Vel + Dt * Accel);

   // �o�ߎ���
   float timer = max(Pos1.w, 0.0f) + Dt;

   // ���W�L�^
   float4 Pos;
   if( ElasticFactor < 999.9f ){
       Pos = Tex.x<0.5f ? Pos1 : float4(Pos2, timer);
   }else{
       Pos = Tex.x<0.5f ? Pos1 : float4(WorldMatrix._41_42_43, timer);
   }

   return Pos;
}

// ���W�X�V
float4 WorldCoord2_PS(float2 Tex: TEXCOORD0) : COLOR
{
   float4 Pos = float4(WorldMatrix._41_42_43, 0.0f);
   return Pos;
}


///////////////////////////////////////////////////////////////////////////////////////
// �I�u�W�F�N�g�`��

// ���_�V�F�[�_
VS_OUTPUT VS_Object( float4 Pos : POSITION, float4 Tex : TEXCOORD0 )
{
    VS_OUTPUT Out;

    // �I�u�W�F�N�g�ʒu�E�X�P�[��
    float3 Pos0 = MaterialDiffuse.rgb * 0.1f;
    float scale = SpecularPower;

    // �I�u�W�F�N�g���W
    Pos.x = 2.0f * (Tex.x - 0.5f);
    Pos.y = 2.0f * (0.5f - Tex.y) + 0.5f;
    Pos.z = 0.0f;

    // �I�u�W�F�N�g�X�P�[��
    Pos.xy *= fireInitScaling * scale;

    // �r���{�[�h+z����]
    Pos.xyz = mul( Pos.xyz, BillboardZRotMatrix );

    // ���[���h���W�ϊ�
    Pos.xyz += Pos0;
    Pos.xyz = mul( Pos, (float3x3)WorldMatrix );
    Pos.xyz += WorldCoordTexArray[1].xyz;

    // �r���[�ˉe�ϊ�
    Out.Pos = mul( Pos, ViewProjMatrix );

    // �e�N�X�`�����W
    Out.Tex = Tex + float2(0.5f/TEX_WORK_WIDTH, 0.5f/TEX_WORK_HEIGHT);

    return Out;
}

// �s�N�Z���V�F�[�_
float4  PS_Object(float2 Tex: TEXCOORD0) : COLOR0
{
    // ���̐F
    float tmp = tex2D(WorkLayerSamp, Tex).r;
    float4 FireCol = tex2D(FireColorSamp, saturate(float2(tmp, 0.5f)));

    // ���̖��邳�̗h�炬
    float s = 1.0f + firePowAmpFactor * (0.66f * sin(2.2f * time * firePowFreqFactor)
                                       + 0.33f * cos(3.3f * time * firePowFreqFactor) );
    // ���ߐݒ�
    #if ADD_FLG == 1
        FireCol.rgb *= 0.8f * s * AcsTr;
    #else
        FireCol.a *= tmp * 0.8f * s * AcsTr;
    #endif

    return FireCol;
}

///////////////////////////////////////////////////////////////////////////////////////
// �e�N�j�b�N

technique MainTec0 < string MMDPass = "object"; string Subset = "0";
    string Script = 
        "RenderColorTarget0=WorkLayer;"
            "RenderDepthStencilTarget=WorkLayerDepthBuffer;"
            "LoopByCount=FrameCount;"
                "LoopGetIndex=RepertIndex;"
                "Pass=FireAnimation;"
            "LoopEnd=;"
        "RenderColorTarget0=WorldCoordTex;"
	    "RenderDepthStencilTarget=WorldCoordDepthBuffer;"
	    "Pass=PosInit;"
	    "Pass=PosUpdate;"
        "RenderColorTarget0=;"
            "RenderDepthStencilTarget=;"
            "Pass=DrawObject;"
    ;
> {
    pass FireAnimation < string Script= "Draw=Buffer;"; > {
        ZWriteEnable = FALSE;
        VertexShader = compile vs_2_0 VS_FireAnimation();
        PixelShader  = compile ps_2_0 PS_FireAnimation(true);
    }
    pass PosInit < string Script = "Draw=Buffer;";>
    {
        ALPHABLENDENABLE = FALSE;
        ALPHATESTENABLE=FALSE;
        VertexShader = compile vs_1_1 WorldCoord_VS();
        PixelShader  = compile ps_2_0 InitWorldCoord_PS();
    }
    pass PosUpdate < string Script = "Draw=Buffer;";>
    {
        ALPHABLENDENABLE = FALSE;
        ALPHATESTENABLE=FALSE;
        VertexShader = compile vs_1_1 WorldCoord_VS();
        PixelShader  = compile ps_2_0 WorldCoord1_PS();
    }
    pass DrawObject {
        ZEnable = TRUE;
        ZWriteEnable = FALSE;
        ALPHABLENDENABLE = TRUE;
        CullMode = NONE;
        #if ADD_FLG == 1
          DestBlend = ONE;
          SrcBlend = ONE;
        #else
          DestBlend = INVSRCALPHA;
          SrcBlend = SRCALPHA;
        #endif
        VertexShader = compile vs_2_0 VS_Object();
        PixelShader  = compile ps_2_0 PS_Object();
    }
}

technique MainTec1 < string MMDPass = "object"; >
{
    pass DrawObject {
        ZEnable = TRUE;
        ZWriteEnable = FALSE;
        ALPHABLENDENABLE = TRUE;
        CullMode = NONE;
        #if ADD_FLG == 1
          DestBlend = ONE;
          SrcBlend = ONE;
        #else
          DestBlend = INVSRCALPHA;
          SrcBlend = SRCALPHA;
        #endif
        VertexShader = compile vs_2_0 VS_Object();
        PixelShader  = compile ps_2_0 PS_Object();
    }
}

technique MainTecSS0 < string MMDPass = "object_ss"; string Subset = "0";
    string Script = 
        "RenderColorTarget0=WorkLayer;"
            "RenderDepthStencilTarget=WorkLayerDepthBuffer;"
            "LoopByCount=FrameCount;"
                "LoopGetIndex=RepertIndex;"
                "Pass=FireAnimation;"
            "LoopEnd=;"
        "RenderColorTarget0=WorldCoordTex;"
	    "RenderDepthStencilTarget=WorldCoordDepthBuffer;"
	    "Pass=PosInit;"
	    "Pass=PosUpdate;"
        "RenderColorTarget0=;"
            "RenderDepthStencilTarget=;"
            "Pass=DrawObject;"
    ;
> {
    pass FireAnimation < string Script= "Draw=Buffer;"; > {
        ZWriteEnable = FALSE;
        VertexShader = compile vs_2_0 VS_FireAnimation();
        PixelShader  = compile ps_2_0 PS_FireAnimation(false);
    }
    pass PosInit < string Script = "Draw=Buffer;";>
    {
        ALPHABLENDENABLE = FALSE;
        ALPHATESTENABLE=FALSE;
        VertexShader = compile vs_1_1 WorldCoord_VS();
        PixelShader  = compile ps_2_0 InitWorldCoord_PS();
    }
    pass PosUpdate < string Script = "Draw=Buffer;";>
    {
        ALPHABLENDENABLE = FALSE;
        ALPHATESTENABLE=FALSE;
        VertexShader = compile vs_1_1 WorldCoord_VS();
        PixelShader  = compile ps_2_0 WorldCoord2_PS();
    }
    pass DrawObject {
        ZEnable = TRUE;
        ZWriteEnable = FALSE;
        ALPHABLENDENABLE = TRUE;
        CullMode = NONE;
        #if ADD_FLG == 1
          DestBlend = ONE;
          SrcBlend = ONE;
        #else
          DestBlend = INVSRCALPHA;
          SrcBlend = SRCALPHA;
        #endif
        VertexShader = compile vs_2_0 VS_Object();
        PixelShader  = compile ps_2_0 PS_Object();
    }
}

technique MainTecSS1 < string MMDPass = "object_ss"; >
{
    pass DrawObject {
        ZEnable = TRUE;
        ZWriteEnable = FALSE;
        ALPHABLENDENABLE = TRUE;
        CullMode = NONE;
        #if ADD_FLG == 1
          DestBlend = ONE;
          SrcBlend = ONE;
        #else
          DestBlend = INVSRCALPHA;
          SrcBlend = SRCALPHA;
        #endif
        VertexShader = compile vs_2_0 VS_Object();
        PixelShader  = compile ps_2_0 PS_Object();
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////

// �G�b�W�͕`�悵�Ȃ�
technique EdgeTec < string MMDPass = "edge"; > { }
// �n�ʉe�͕\�����Ȃ�
technique ShadowTec < string MMDPass = "shadow"; > { }
// MMD�W���̃Z���t�V���h�E�͕\�����Ȃ�
technique ZplotTec < string MMDPass = "zplot"; > { }

