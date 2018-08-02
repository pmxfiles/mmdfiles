////////////////////////////////////////////////////////////////////////////////////////////////
//  M4Toon.fx
//  Toon ���l�����܂�
//  臒l�ȏ�̌��� (���Z�X�t�B�A�}�b�v, �X�y�L����) �̐F���V�t�g�A�C�ӂ̒l�̏�Z����щ��Z�A�K�p���̎w�肪�ł��܂�
//  �e (�Z���t�V���h�E, �g�D�[���e) �̐F���V�t�g�A�C�ӂ̒l�̏�Z����щ��Z�A�K�p���̎w�肪�ł��܂�
//  �A�N�Z�T���ɃG�b�W�����܂�
//  �쐬: �~�[�t�H��
//  
//  ��Z�Ɖ��Z�̐F�ƒl�������Ӗ��̂��̂������̂� MikuMikuMoving �ł̎w��̓s���ɂ����̂ł�
//  
////////////////////////////////////////////////////////////////////////////////////////////////
//  ���ό� SampleFull_v2_edge.fx
//
//  ����s��}��
//  �ꕔ�����ʂ��ς��Ȃ��悤�ɕύX
//  MMM�Ǝ��̃p�����[�^��ǉ��B�����ɂ͖��֌W
//  �j��P�����L�L�ڃG�t�F�N�g�����ɃG�b�W������ǉ�

//  MikuMikuMoving_v0531_beta�œ���m�F
//  2012/04/16 �X�V
//  �쐬: beat32lop��
//
////////////////////////////////////////////////////////////////////////////////////////////////
//  ���ό� SampleBase.fxm
//  MikuMikuMoving�p�T���v���V�F�[�_
//  2012/03/17�X�V
//  �쐬: Mogg��
//
////////////////////////////////////////////////////////////////////////////////////////////////
//  EdgeControl.fx ver0.0.3  �G�b�W��MMD�̕W���V�F�[�_��p�����ɓƎ��d�l�ŕ`�悵�܂�
//  �쐬: �j��P��( ���͉��P����full.fx���� )

////////////////////////////////////////////////////////////////////////////////////////////////
// �p�����[�^�錾

// �R���g���[���t�@�C����
#define CONTROLLER_NAME "M4ToonController.pmd"

// �G�b�W���A�N�Z�T���ɑ΂��Ă��`�悷�邩 (�����ɂ���ꍇ�͕����� // ������)
#define EDGE_FOR_ACCESSORIES

// �A�N�Z�T���G�b�W����
float EdgeThicknessMultiply = 0.75;

// �e��f�t�H���g�l

float ToonThreshold
<
	string UIName = "�g�D�[�����E";
	string UIHelp = "Toon �K�p���l������臒l���w�肵�܂��B";
	string UIWidget = "Slider";
	float UIMin = 0;
	float UIMax = 1;
> = 0.5;
float ShadowStrength
<
	string UIName = "�e�Z�x";
	string UIHelp = "�e�̔Z�����w�肵�܂��B";
	string UIWidget = "Slider";
	float UIMin = 0;
	float UIMax = 1;
> = 0.7;
float SpecularStrength
<
	string UIName = "����Z�x";
	string UIHelp = "���� (���Z�X�t�B�A�}�b�v/�X�y�L����) �̔Z�����w�肵�܂��B";
	string UIWidget = "Slider";
	float UIMin = 0;
	float UIMax = 1;
> = 1.5;
float SphereStrength
<
	string UIName = "��Z�X�t�B�A�Z�x";
	string UIHelp = "��Z�X�t�B�A�}�b�v�̔Z�����w�肵�܂��B";
	string UIWidget = "Slider";
	float UIMin = 0;
	float UIMax = 1;
> = 0.75;
float SpherePower
<
	string UIName = "�X�t�B�A���x";
	string UIHelp = "�X�t�B�A�}�b�v�̋����x���w�肵�܂��B";
	string UIWidget = "Slider";
	float UIMin = 0;
	float UIMax = 1;
> = 0;

float BaseMultiplyValue
<
	string UIName = "�S�̏�Z�l";
	string UIHelp = "�S�̂ɏ�Z����l���w�肵�܂��B";
	string UIWidget = "Slider";
	float UIMin = -2;
	float UIMax = 2;
> = 0.9;
float BaseAddValue
<
	string UIName = "�S�̉��Z�l";
	string UIHelp = "�S�̂ɏ�Z����l���w�肵�܂��B";
	string UIWidget = "Slider";
	float UIMin = -2;
	float UIMax = 2;
> = 0.12;

float SpecularThreshold
<
	string UIName = "���򑀍�臒l";
	string UIHelp = "�����F���ύX����Œ��l���e�F�̕��ϒl�Ŏw�肵�܂��B";
	string UIWidget = "Slider";
	float UIMin = 0;
	float UIMax = 1;
> = 0.2;
float3 LowerSpecularMultiplyValue
<
	string UIName = "������Z�l";
	string UIHelp = "臒l�ɖ����Ȃ�����ɏ�Z����l���w�肵�܂��B";
	string UIWidget = "Slider";
	float3 UIMin = -2;
	float3 UIMax = 2;
> = 0;
float3 SpecularMultiplyColor
<
	string UIName = "�����Z�F";
	string UIHelp = "����ɏ�Z����F���w�肵�܂��B";
	string UIWidget = "Color";
> = float3(1, 1, 1);
float3 SpecularMultiplyValue
<
	string UIName = "�����Z�l";
	string UIHelp = "����ɏ�Z����l���w�肵�܂��B";
	string UIWidget = "Slider";
	float3 UIMin = -2;
	float3 UIMax = 2;
> = float3(1.25, 1.25, 1.25);
float3 SpecularAddColor
<
	string UIName = "������Z�F";
	string UIHelp = "����ɉ��Z����F���w�肵�܂��B";
	string UIWidget = "Color";
> = float3(0, 0, 0);
float3 SpecularAddValue
<
	string UIName = "������Z�l";
	string UIHelp = "����ɉ��Z����l���w�肵�܂��B";
	string UIWidget = "Slider";
	float3 UIMin = -2;
	float3 UIMax = 2;
> = float3(0, 0, 0);

float3 ShadowMultiplyColor
<
	string UIName = "�e��Z�F";
	string UIHelp = "�e�ɏ�Z����F���w�肵�܂��B";
	string UIWidget = "Color";
> = float3(1, 0.9, 0.8);
float3 ShadowMultiplyValue
<
	string UIName = "�e��Z�l";
	string UIHelp = "�e�ɏ�Z����l���w�肵�܂��B";
	string UIWidget = "Slider";
	float3 UIMin = -2;
	float3 UIMax = 2;
> = float3(1, 1, 1);
float3 ShadowAddColor
<
	string UIName = "�e���Z�F";
	string UIHelp = "�A�ɉ��Z����F���w�肵�܂��B";
	string UIWidget = "Color";
> = float3(0, 0, 0);
float3 ShadowAddValue
<
	string UIName = "�e���Z�l";
	string UIHelp = "�e�ɉ��Z����l���w�肵�܂��B";
	string UIWidget = "Slider";
	float3 UIMin = -2;
	float3 UIMax = 2;
> = float3(0, 0, 0);

float SpecularHuePreShift
<
	string UIName = "���򑊎��O�V�t�g";
	string UIHelp = "����̐F�����V�t�g����l���f�B�O���[�Ŏw�肵�܂��B";
	string UIWidget = "Slider";
	float UIMin = -180;
	float UIMax = 180;
> = 0;
float SpecularHuePostShift
<
	string UIName = "���򑊎���V�t�g";
	string UIHelp = "����̐F�����V�t�g����l���f�B�O���[�Ŏw�肵�܂��B";
	string UIWidget = "Slider";
	float UIMin = -180;
	float UIMax = 180;
> = 0;
float ShadowHuePreShift
<
	string UIName = "�e�F�����O�V�t�g";
	string UIHelp = "�e�̐F�����V�t�g����l���f�B�O���[�Ŏw�肵�܂��B";
	string UIWidget = "Slider";
	float UIMin = -180;
	float UIMax = 180;
> = -20;
float ShadowHuePostShift
<
	string UIName = "�e�F������V�t�g";
	string UIHelp = "�e�̐F�����V�t�g����l���f�B�O���[�Ŏw�肵�܂��B";
	string UIWidget = "Slider";
	float UIMin = -180;
	float UIMax = 180;
> = 0;

////////////////////////////////////////////////////////////////////////////////////////////////

bool controllerVisible : CONTROLOBJECT < string name = CONTROLLER_NAME; >;
float controllerThresholdToon : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "�g�D�[�����E"; >;
float controllerStrengthSpecular : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "����Z�x"; >;
float controllerStrengthShadow : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "�e�Z�x"; >;
float controllerStrengthSphere : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "�X�t�B�A�Z�x"; >;
float controllerPowerSphere : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "�X�t�B�A���x"; >;
float controllerThresholdSpecular : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "����臒l"; >;
float controllerMultiplyBase : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "��Z�S��"; >;
float controllerAddBase : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "���Z�S��"; >;
float controllerMultiplyLowerSpecularR : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "R��Z�����"; >;
float controllerMultiplyLowerSpecularG : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "G��Z�����"; >;
float controllerMultiplyLowerSpecularB : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "B��Z�����"; >;
float controllerMultiplySpecularR : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "R��Z����"; >;
float controllerMultiplySpecularG : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "G��Z����"; >;
float controllerMultiplySpecularB : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "B��Z����"; >;
float controllerAddSpecularR : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "R���Z����"; >;
float controllerAddSpecularG : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "G���Z����"; >;
float controllerAddSpecularB : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "B���Z����"; >;
float controllerMultiplyShadowR : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "R��Z�e"; >;
float controllerMultiplyShadowG : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "G��Z�e"; >;
float controllerMultiplyShadowB : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "B��Z�e"; >;
float controllerAddShadowR : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "R���Z�e"; >;
float controllerAddShadowG : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "G���Z�e"; >;
float controllerAddShadowB : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "B���Z�e"; >;
float controllerHueSpecularPre : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "�F���O����"; >;
float controllerHueSpecularPost : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "�F�������"; >;
float controllerHueShadowPre : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "�F���O�e"; >;
float controllerHueShadowPost : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "�F����e"; >;

//���@�ϊ��s��
float4x4 WorldViewProjMatrix      : WORLDVIEWPROJECTION;
float4x4 WorldMatrix              : WORLD;
float4x4 ViewMatrix               : VIEW;

//�G�b�W�p�ɒǉ�
float4x4 ProjMatrix               : PROJECTION;
float4x4 ViewProjMatrix           : VIEWPROJECTION;

//�J�����ʒu
float3   CameraPosition    : POSITION  < string Object = "Camera"; >;

// �}�e���A���F
float4   MaterialDiffuse   : DIFFUSE  < string Object = "Geometry"; >;
//static float4   MaterialDiffuse = float4(0,0,0,1);
float3   MaterialAmbient   : AMBIENT  < string Object = "Geometry"; >;
//static float3   MaterialAmbient = MaterialDiffuse.rgb;
float3   MaterialEmmisive  : EMISSIVE < string Object = "Geometry"; >;
float3   MaterialSpecular  : SPECULAR < string Object = "Geometry"; >;
float    SpecularPower     : SPECULARPOWER < string Object = "Geometry"; >;
float3   MaterialToon      : TOONCOLOR;

//�G�b�W�F�ƃG�b�W����
float3   EdgeColor         : EDGECOLOR < string Object = "Geometry"; >;
float    EdgeWidth         : EDGEWIDTH < string Object = "Geometry"; >;


// ���C�g�F
float3   LightDiffuse      : DIFFUSE   < string Object = "Light"; >;
float3   LightAmbient      : AMBIENT   < string Object = "Light"; >;
float3   LightSpecular     : SPECULAR  < string Object = "Light"; >;

// MME�p�̃p�����[�^
#ifndef MIKUMIKUMOVING

float4x4 LightWorldViewProjMatrix : WORLDVIEWPROJECTION < string Object = "Light"; >;
float3   LightDirection0    : DIRECTION < string Object = "Light"; >;

// �݊��p�ɍĒ�`
static float3   LightDirection[1] = {LightDirection0};
static float3   LightDiffuses [3] = {LightDiffuse, LightDiffuse, LightDiffuse};
static float3   LightAmbients [3] = {LightAmbient, LightAmbient, LightAmbient};
static float3   LightSpeculars[3] = {LightSpecular, LightSpecular, LightSpecular};

//�ގ����[�t�֘A
float4	 AddingTexture   = (0,0,0,0);
float4	 AddingSphere    = (0,0,0,0);
float4	 MultiplyTexture = (1,1,1,1);
float4	 MultiplySphere  = (1,1,1,1);

static float MMM_LightCount = 1;
static bool  LightEnables[3] = {true, false, false};		// �L���t���O


#else

//���C�g�֘A
//�V�����ǉ����ꂽ�t���O
bool	 LightEnables[MMM_LightCount]		: LIGHTENABLES;		// �L���t���O
//���@�ϊ��s�񂩂炱����Ɉړ������B[]�̓��C�g�̔ԍ��ŁA�f�t�H���g����0�A1�A2�̂ǂꂩ
float4x4 LightWVPMatrices[MMM_LightCount]	: LIGHTWVPMATRICES;	// ���W�ϊ��s��
float3   LightDirection[MMM_LightCount]		: LIGHTDIRECTIONS;	// ����

//��������V�����ǉ����ꂽ����
//�ގ����[�t�֘A
float4	 AddingTexture		  : ADDINGTEXTURE;	// �ގ����[�t���ZTexture�l
float4	 AddingSphere		  : ADDINGSPHERE;	// �ގ����[�t���ZSphereTexture�l
float4	 MultiplyTexture	  : MULTIPLYINGTEXTURE;	// �ގ����[�t��ZTexture�l
float4	 MultiplySphere		  : MULTIPLYINGSPHERE;	// �ގ����[�t��ZSphereTexture�l

//�������ύX���ꂽ�Z���t�V���h�E�̌v�Z�Ɏg�p
//�e�̔Z��
float	 ShadowDeepPositive       : SHADOWDEEP_POSITIVE;
float	 ShadowDeepNegative       : SHADOWDEEP_NEGATIVE;
float	 ShadowDeep               : SHADOWDEEP;	// �ʏ�̔Z��

//���ꂼ��3�̃��C�g�Ɋ��蓖�Ă��Ă���
// ���C�g�F
float3   LightDiffuses[MMM_LightCount]      : LIGHTDIFFUSECOLORS;
float3   LightAmbients[MMM_LightCount]      : LIGHTAMBIENTCOLORS;
float3   LightSpeculars[MMM_LightCount]     : LIGHTSPECULARCOLORS;

#endif


// ���C�g�F
//���C�g���R�ɑ������̂ŁA����ɂƂ��Ȃ��Ă�������R�ɂȂ���
static float4 DiffuseColor[3]  = { MaterialDiffuse * float4(LightDiffuses[0], 1.0f)
				 , MaterialDiffuse * float4(LightDiffuses[1], 1.0f)
				 , MaterialDiffuse * float4(LightDiffuses[2], 1.0f)};
static float3 AmbientColor[3]  = { saturate(MaterialAmbient * LightAmbients[0] + MaterialEmmisive)
				 , saturate(MaterialAmbient * LightAmbients[1] + MaterialEmmisive)
				 , saturate(MaterialAmbient * LightAmbients[2] + MaterialEmmisive)};
static float3 SpecularColor[3] = { MaterialSpecular * LightSpeculars[0]
				 , MaterialSpecular * LightSpeculars[1]
				 , MaterialSpecular * LightSpeculars[2]};

bool     parthf;   // �p�[�X�y�N�e�B�u�t���O
bool	use_texture;		// �e�N�X�`���g�p
bool	use_spheremap;		// �X�t�B�A�}�b�v�g�p
bool	use_toon;			// �g�D�[���`�悩�ǂ��� (�A�N�Z�T��: false, ���f��: true)
bool	transp;				// �������t���O
bool	spadd;				// �X�t�B�A�}�b�v���Z�����t���O
#define SKII1    1500
#define SKII2    8000
#define Toon     3

// �I�u�W�F�N�g�̃e�N�X�`��
texture ObjectTexture: MATERIALTEXTURE;
sampler ObjTexSampler = sampler_state {
    texture = <ObjectTexture>;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};

// �X�t�B�A�}�b�v�̃e�N�X�`��
texture ObjectSphereMap: MATERIALSPHEREMAP;
sampler ObjSphareSampler = sampler_state {
    texture = <ObjectSphereMap>;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};


#ifndef MIKUMIKUMOVING

// MMD�{����sampler���㏑�����Ȃ����߂̋L�q�ł��B�폜�s�B
sampler MMDSamp0 : register(s0);
sampler MMDSamp1 : register(s1);
sampler MMDSamp2 : register(s2);

#else

bool    usetoontexturemap;

#endif

///////////////////////////////////////////////////////////////////////////////////////////////
// �֊s�`��i�G�b�W�j
// ���_�V�F�[�_(�`��p)

#ifdef MIKUMIKUMOVING

float4 Edge_VS(MMM_SKINNING_INPUT IN) : POSITION
{
    //================================================================================
    //MikuMikuMoving�Ǝ��̃X�L�j���O�֐�(MMM_SkinnedPositionNormal)�B���W�Ɩ@�����擾����B
    //================================================================================
    MMM_SKINNING_OUTPUT SkinOut = MMM_SkinnedPositionNormal(IN.Pos, IN.Normal, IN.BlendWeight, IN.BlendIndices, IN.SdefC, IN.SdefR0, IN.SdefR1);
    // ���[���h���W�ϊ�
    float4 Pos = mul( SkinOut.Position, WorldMatrix );
    float3 Normal = normalize( mul( SkinOut.Normal, (float3x3)WorldMatrix ) );
    
//  IN.EdgeWeight�Ń��f���̃G�b�W�������擾
//    float EdgeThickness = IN.EdgeWeight *0.5 *ThicknessRate;
//  �ǉ����ꂽ�@�\EdgeWidth�������B���f���v���p�e�B�̃G�b�W�������擾���Ă���H
//    float EdgeThickness = EdgeWidth * 1000;
//  ���f���̃G�b�W�����~���f���v���p�e�B�̃G�b�W����
//    float EdgeThickness = IN.EdgeWeight * EdgeWidth * 1000 *ThicknessRate;
    float EdgeThickness = (use_toon ? IN.EdgeWeight * EdgeWidth * 1000 : 1) * EdgeThicknessMultiply;

    // �J�����Ƃ̋���
    float len = max( length( CameraPosition - Pos ), 5.0f );

    // ���_��@�������ɉ����o��
    Pos.xyz += Normal * ( len * EdgeThickness * 0.0015f * pow(2.4142f / ProjMatrix._22, 0.7f) );

    // �J�������_�̃r���[�ˉe�ϊ�
    Pos = mul( Pos, ViewProjMatrix );

    return Pos;
}

#else
float4 Edge_VS(float4 Pos : POSITION, float3 Normal : NORMAL) : POSITION
{
	float EdgeThickness = 1.0f * EdgeThicknessMultiply;

    // ���[���h���W�ϊ�
    Pos = mul( Pos, WorldMatrix );
    Normal = normalize( mul( Normal, (float3x3)WorldMatrix ) );

    // �J�����Ƃ̋���
    float len = max( length( CameraPosition - Pos ), 5.0f );

    // ���_��@�������ɉ����o��
    Pos.xyz += Normal * ( len * EdgeThickness * 0.0015f * pow(2.4142f / ProjMatrix._22, 0.7f) );

    // �J�������_�̃r���[�ˉe�ϊ�
    Pos = mul( Pos, ViewProjMatrix );

    return Pos;
}
#endif


// �s�N�Z���V�F�[�_(�`��p)
float4 Edge_PS() : COLOR
{
    // �֊s�F�œh��Ԃ�
    return saturate ( float4( EdgeColor,1));
    
}
///////////////////////////////////////////////////////////////////////////////////////////////
// �֊s�`��p�e�N�j�b�N

technique EdgeTec0 < string MMDPass = "edge"; > {
    pass DrawEdge {
        CullMode = CW;
        AlphaBlendEnable = FALSE;
        AlphaTestEnable  = FALSE;
        
        VertexShader = compile vs_2_0 Edge_VS();
        PixelShader  = compile ps_2_0 Edge_PS();
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////
// �Z���t�V���h�E�pZ�l�v���b�g

#ifndef MIKUMIKUMOVING

struct VS_ZValuePlot_OUTPUT {
    float4 Pos : POSITION;              // �ˉe�ϊ����W
    float4 ShadowMapTex : TEXCOORD0;    // Z�o�b�t�@�e�N�X�`��
};

// ���_�V�F�[�_
VS_ZValuePlot_OUTPUT ZValuePlot_VS( float4 Pos : POSITION )
{
    VS_ZValuePlot_OUTPUT Out = (VS_ZValuePlot_OUTPUT)0;

    // ���C�g�̖ڐ��ɂ�郏�[���h�r���[�ˉe�ϊ�������
    Out.Pos = mul( Pos, LightWorldViewProjMatrix );

    // �e�N�X�`�����W�𒸓_�ɍ��킹��
    Out.ShadowMapTex = Out.Pos;

    return Out;
}
// �s�N�Z���V�F�[�_
float4 ZValuePlot_PS( float4 ShadowMapTex : TEXCOORD0 ) : COLOR
{
    // R�F������Z�l���L�^����
    return float4(ShadowMapTex.z/ShadowMapTex.w,0,0,1);
}

// Z�l�v���b�g�p�e�N�j�b�N
// MMM�ł�string MMDPass = "zplot"; ����������Ă���Ǝv��
technique ZplotTec < string MMDPass = "zplot"; > {
    pass ZValuePlot {
        AlphaBlendEnable = FALSE;
        VertexShader = compile vs_2_0 ZValuePlot_VS();
        PixelShader  = compile ps_2_0 ZValuePlot_PS();
    }
}


// �V���h�E�o�b�t�@�̃T���v���B"register(s0)"�Ȃ̂�MMD��s0���g���Ă��邩��
sampler DefSampler : register(s0);

#endif

///////////////////////////////////////////////////////////////////////////////////////////////
// �I�u�W�F�N�g�`��i�Z���t�V���h�EON/OFF���ʁj


//  �ύX�ӏ��͍��ڂ̒ǉ��Ȃ̂ŁA���ɖ��Ȃ��g����
struct VS_OUTPUT {
    float4 Pos        : POSITION;    // �ˉe�ϊ����W
    float4 ZCalcTex : TEXCOORD0;    // Z�l
    float2 Tex        : TEXCOORD1;   // �e�N�X�`��
    float3 Normal     : TEXCOORD2;   // �@��
    float3 Eye        : TEXCOORD3;   // �J�����Ƃ̑��Έʒu
    float2 SpTex      : TEXCOORD4;   // �X�t�B�A�}�b�v�e�N�X�`�����W
    // MME����ZCalcTex�̑���Ɏg��
    float4 SS_UV1     : TEXCOORD5;   // �Z���t�V���h�E�e�N�X�`�����W
    float4 SS_UV2     : TEXCOORD6;   // �Z���t�V���h�E�e�N�X�`�����W
    float4 SS_UV3     : TEXCOORD7;   // �Z���t�V���h�E�e�N�X�`�����W
    float4 Color      : COLOR0;      // �f�B�t���[�Y�F
};

//** �F���V�t�g
// shift �� -360�`360
static float3 ShiftHue(float3 rgb, float shift)
{
	float maxValue = max(rgb.r, max(rgb.g, rgb.b));
	float minValue = min(rgb.r, min(rgb.g, rgb.b));
	float delta = maxValue - minValue;
	float3 hsv = float3(0, maxValue == 0 ? 0 : delta / maxValue, maxValue);
	
	if (delta <= 0.000001)
		return rgb;
	else
	{
		hsv.x =
			rgb.r + 0.000001 >= maxValue ? (rgb.g - rgb.b) / delta :
			rgb.g + 0.000001 >= maxValue ? (rgb.b - rgb.r) / delta + 2 :
									 	   (rgb.r - rgb.g) / delta + 4;
		hsv.x *= 60;
		hsv.x += shift;
		hsv.x = hsv.x < 0
			? hsv.x + 360
			: hsv.x >= 360
				? hsv.x - 360
				: hsv.x;
		
		hsv.x /= 60;
		
		int i = floor(hsv.x);
		float f = hsv.x - i;
		float p = hsv.z * (1 - hsv.y);
		float q = hsv.z * (1 - f * hsv.y);
		float t = hsv.z * (1 - (1 - f) * hsv.y);
		
		if (i < 1)
			return float3(hsv.z, t, p);
		else if (i < 2)
			return float3(q, hsv.z, p);
		else if (i < 3)
			return float3(p, hsv.z, t);
		else if (i < 4)
			return float3(p, q, hsv.z);
		else if (i < 5)
			return float3(t, p, hsv.z);
		else
			return float3(hsv.z, p, q);
	}
}

//** a �� 0 �Ȃ� b
float DefaultIfZero(float a, float b)
{
	return !controllerVisible && a == 0 ? b : a;
}
float3 DefaultIfZero3(float3 a, float3 b)
{
	return !controllerVisible && a == 0 ? b : a;
}

// ���Ȃ�C���������Ƃ���ŕ��򂵂܂��̂Œ���
#ifdef MIKUMIKUMOVING
//==============================================
// ���_�V�F�[�_
// MikuMikuMoving�Ǝ��̒��_�V�F�[�_����(MMM_SKINNING_INPUT)
//==============================================
//  �Z���t�V���h�E�t���O�� uniform bool useSelfShadow ���ǉ�����Ă���
VS_OUTPUT Basic_VS(MMM_SKINNING_INPUT IN, uniform bool useSelfShadow)
{
    
    //================================================================================
    //MikuMikuMoving�Ǝ��̃X�L�j���O�֐�(MMM_SkinnedPositionNormal)�B���W�Ɩ@�����擾����B
    //================================================================================
    MMM_SKINNING_OUTPUT SkinOut = MMM_SkinnedPositionNormal(IN.Pos, IN.Normal, IN.BlendWeight, IN.BlendIndices, IN.SdefC, IN.SdefR0, IN.SdefR1);
    float4 Pos = SkinOut.Position;
    float3 Normal = SkinOut.Normal;
    float2 Tex = IN.Tex;
    // �� fx���̋L�q�ɍ��킹���B�ȉ��Afx�̏������R�s�y����ΑΉ��ł��邩���B
    

// MME�p
// ���_�V�F�[�_
#else
// uniform bool useSelfShadow��ǉ�
VS_OUTPUT Basic_VS(float4 Pos : POSITION, float3 Normal : NORMAL, float2 Tex : TEXCOORD0, uniform bool useSelfShadow)
{
#endif
    
    VS_OUTPUT Out = (VS_OUTPUT)0;
    
    // ���_���W
    Out.Pos = mul(Pos, WorldViewProjMatrix);
    // ���_�@��
    Out.Normal = normalize( mul( Normal, (float3x3)WorldMatrix ) );
    // �J�����Ƃ̑��Έʒu
    Out.Eye = CameraPosition - mul(Pos, WorldMatrix);
    
    // �f�B�t���[�Y�F�{�A���r�G���g�F �v�Z
//    Out.Color.rgb = AmbientColor[0];
    // �F���v�Z
    float3 color = float3(0, 0, 0);
    float count = 0;

//  Light�̌v�Z�B���ȊO��MMD�ƕς�炸
//  �R�s�y����Ƃ��͍����ւ��Ȃ��悤�ɒ��ӁB�����ւ���ƏƖ�1���������Ȃ��Ȃ�
    if (LightEnables[0]) {
        color += AmbientColor[0] + max(0, DiffuseColor[0] * dot(Out.Normal, -LightDirection[0]));
        count += 1.0f;
    }

    for (int i = 1; i < MMM_LightCount; i++) {
        if (LightEnables[i]) {
            color += AmbientColor[i] + max(0, DiffuseColor[i] * dot(Out.Normal, -LightDirection[i]));
            count += 1.0f;
        }
    }
    Out.Color.rgb = saturate(color / count);
    Out.Color.a = DiffuseColor[0].a;
    
    // �e�N�X�`�����W
    Out.Tex = Tex;
    
    if (use_spheremap) {
        // �X�t�B�A�}�b�v�e�N�X�`�����W
        float2 NormalWV = mul(Out.Normal, (float3x3)ViewMatrix);
        Out.SpTex.x = NormalWV.x * 0.5f + 0.5f;
        Out.SpTex.y = NormalWV.y * -0.5f + 0.5f;
    }

#ifdef MIKUMIKUMOVING
//  �Z���t�V���h�E�͕ύX���ꂽ
    if (useSelfShadow)
    {
        //�Z���t�V���h�E�f�v�X�}�b�v�e�N�X�`�����W���v�Z
        float4 dpos = mul(Pos, WorldMatrix);
        // ���C�g���_�ɂ�郏�[���h�r���[�ˉe�ϊ�
        Out.SS_UV1 = mul(dpos, LightWVPMatrices[0]);
        Out.SS_UV2 = mul(dpos, LightWVPMatrices[1]);
        Out.SS_UV3 = mul(dpos, LightWVPMatrices[2]);
    }
    
// �K�v�Ȃ̂�1���������A�����݊��p��MME���ł�����Ă���
#else
	// ���C�g���_�ɂ�郏�[���h�r���[�ˉe�ϊ�
    Out.SS_UV1 = mul( Pos, LightWorldViewProjMatrix );
#endif
    
    return Out;
}

//==============================================
// �s�N�Z���V�F�[�_
// ���͓͂��ɓƎ��`���Ȃ�
//==============================================
float4 Basic_PS(VS_OUTPUT IN, uniform bool useSelfShadow) : COLOR0
{
	//** Toon ��g�p�ӏ��ɉe��t���Ȃ�
	if (use_toon)
	#ifndef MIKUMIKUMOVING
		use_toon = MaterialToon != float3(1, 1, 1);
	#else
		use_toon = usetoontexturemap;
	#endif
	
    // �X�y�L�����F�v�Z(���C�g0�̂ݔ��f)
    float3 HalfVector = normalize(normalize(IN.Eye) + -LightDirection[0]);
    float3 Specular = pow(max(0,dot( HalfVector, normalize(IN.Normal))), SpecularPower) * SpecularColor[0];
    
    float4 Color = IN.Color;
    float4 ShadowColor = float4(AmbientColor[0], Color.a);  // �e�̐F
    float4 texColor = float4(1, 1, 1, 1);
    float  texAlpha = MultiplyTexture.a + AddingTexture.a;
    if (use_texture) {
        // �e�N�X�`���K�p
        texColor = tex2D(ObjTexSampler, IN.Tex);
        texColor.rgb = (texColor.rgb * MultiplyTexture.rgb + AddingTexture.rgb) * texAlpha + (1.0 - texAlpha);
    }
    
    // �������P�s�ɓ���
    Color *= texColor;
    ShadowColor *= texColor;

	//** �x�[�X�F�ۑ�
	float3 baseColor = Color.rgb;

    if (use_spheremap)
    {
        float sp = DefaultIfZero(controllerPowerSphere, SpherePower);
        float4 stex = tex2D(ObjSphareSampler,IN.SpTex);
    	
    	//** �X�t�B�A�}�b�v����
        stex.rgb = lerp(stex.rgb, max(pow(stex.rgb, 16), 0) * 10, sp);
        
        // �X�t�B�A�}�b�v�K�p
        if(spadd)
        {
        	Color.rgb += stex.rgb;
        	ShadowColor.rgb += stex.rgb;
        } else {
        	float ss = DefaultIfZero(controllerStrengthSphere, SphereStrength);
        	
        	//** ��Z�X�t�B�A�̏ꍇ�A�K�p����K�p���x�[�X�F�X�V
        	Color.rgb = lerp(Color.rgb, Color.rgb * stex.rgb, ss);
        	ShadowColor.rgb = lerp(ShadowColor.rgb, ShadowColor.rgb * stex.rgb, ss);
        	baseColor = Color.rgb;
        }
    }
    
    //Toon�̐F(���C�g0�̂ݔ��f)
    //����̗L���ɂ�����炸���p����̂ł����Ɉړ�
    float LightNormal = dot( IN.Normal, -LightDirection[0] );
    float3 shadow = lerp(MaterialToon, float3(1,1,1), saturate(LightNormal * 16 + 0.5));
    
    if (!useSelfShadow && use_toon) {
        // �g�D�[���K�p
        Color.rgb *= shadow;
        
        //** TODO:�����ɂ��e�ϐF�����ׂ��Ȃ񂾂��ǖʓ|���̂Ŕ�Ή�
        baseColor *= shadow;
    }
    
    // full.fx�ɍ��킹�Ă��̈ʒu��
    // �X�y�L�����K�p
    Color.rgb += Specular;

	//** �l����̂��ʓ|�Ȃ̂Ō��򍇐�������
	float3 added = Color.rgb - baseColor;
	
	if ((added.r + added.g + added.b) / 3 > DefaultIfZero(controllerThresholdSpecular, SpecularThreshold))
		Color.rgb = saturate
		(
			baseColor
			+ ShiftHue
			(
				ShiftHue(added, DefaultIfZero(controllerHueSpecularPre * 360, SpecularHuePreShift))
				* DefaultIfZero3
				(
					float3(controllerMultiplySpecularR, controllerMultiplySpecularG, controllerMultiplySpecularB),
					SpecularMultiplyColor * SpecularMultiplyValue
				)
				+ DefaultIfZero3
				(
					float3(controllerAddSpecularR, controllerAddSpecularG, controllerAddSpecularB),
					SpecularAddColor + SpecularAddValue
				),
				DefaultIfZero(controllerHueSpecularPost * 360, SpecularHuePostShift)
			) * DefaultIfZero(controllerStrengthSpecular, SpecularStrength)
		);
	else
		Color.rgb = saturate(baseColor + added * DefaultIfZero3
		(
			float3(controllerMultiplyLowerSpecularR, controllerMultiplyLowerSpecularG, controllerMultiplyLowerSpecularB),
			LowerSpecularMultiplyValue
		));

// �������ς�����Z���t�V���h�E
    //�Z���t�V���h�E
    if (useSelfShadow && use_toon)
    {
        float smz, comp, tt, count;
        float2 texcoord;
        float3 color = float3(1,1,1);
        //  �F�ۑ��p
        float4 ans = float4(0,0,0,0);
        float4 d;
        float4 uv[3];
        uv[0] = IN.SS_UV1;
        uv[1] = IN.SS_UV2;
        uv[2] = IN.SS_UV3;

        //�Z���t�V���h�E�F���v�Z
#ifdef MIKUMIKUMOVING
        for (int i = 0; i < 3; i++)
        {
#endif

#ifdef MIKUMIKUMOVING
            tt = uv[i].z;
            // �e�N�X�`�����W�ɕϊ�
            texcoord = float2(1.0f + uv[i].x / uv[i].w, 1.0f - uv[i].y / uv[i].w) * 0.5f;

            //================================================================================
            // MikuMikuMoving�Ǝ��̐[�x���擾�֐�(MMM_UnpackDepth)
            //================================================================================
            d = tex2D(MMM_SelfShadowSampler[i], texcoord);
            // d.x���Ɣ�r���Z�ł��Ȃ��̂�MMM_UnpackDepth()���K�v�H
            // �܂��AMMM_UnpackDepth()�̎��_��MMD�ƌv�Z���قȂ��Ă���?
            // �E�ӂɐ��l�𑫂��̂̓W���M�[�΍�B�傫������Ήe���������Ȃ�
            smz = MMM_UnpackDepth(d) + 0.0001;
            if (tt > smz)
            {
                //�F�̔Z�����v�Z
                // �Z���t�V���h�E mode1
//                comp = 1.0 - saturate( (tt - smz) * SKII1 -0.3f);
                // �Z���t�V���h�E mode2�ɑ������Ă邩��
                comp = 1.0 - saturate( (tt - smz) * SKII2 *ShadowDeep -0.3f);
            }
            
//MME�p����
#else
            // �e�N�X�`�����W�ɕϊ�
            uv[0] = IN.SS_UV1;
            uv[0] /= uv[0].w;
            float2 TransTexCoord;
            TransTexCoord.x = (1.0f + uv[0].x)*0.5f;
            TransTexCoord.y = (1.0f - uv[0].y)*0.5f;
            if( any( saturate(TransTexCoord) != TransTexCoord ) ) {
                // �V���h�E�o�b�t�@�O
                use_toon = false;
                ans = Color;
            } else {
                if(parthf) {
                // �Z���t�V���h�E mode2
                   comp=1-saturate(max(uv[0].z-tex2D(DefSampler,TransTexCoord).r , 0.0f)*SKII2*TransTexCoord.y-0.3f);
                } else {
                // �Z���t�V���h�E mode1
                   comp=1-saturate(max(uv[0].z-tex2D(DefSampler,TransTexCoord).r , 0.0f)*SKII1-0.3f);
                }
            }
  
#endif
            
            
            // ���[�v�΍�
            float4 shadowcolor = Color;
//            float4 shadowcolor;
            
            if ( use_toon ) {
            // �g�D�[���K�p
	            comp = min(saturate(LightNormal*Toon),comp);
	            shadowcolor.rgb = ShadowColor.rgb *MaterialToon;
	        //ans += lerp(shadowcolor, Color, comp);
	        
				//**�g�D�[���F����
				shadowcolor.rgb *= baseColor.rgb;
				shadowcolor.rgb = ShiftHue(shadowcolor.rgb, DefaultIfZero(controllerHueShadowPre * 360, ShadowHuePreShift));
				shadowcolor.rgb *= DefaultIfZero3
				(
					float3(controllerMultiplyShadowR, controllerMultiplyShadowG, controllerMultiplyShadowB),
					ShadowMultiplyColor * ShadowMultiplyValue
				);
				shadowcolor.rgb += DefaultIfZero3
				(
					float3(controllerAddShadowR, controllerAddShadowG, controllerAddShadowB),
					ShadowAddColor + ShadowAddValue
				);
				shadowcolor.rgb = lerp(saturate(shadowcolor.rgb), Color.rgb, 1 - DefaultIfZero(controllerStrengthShadow, ShadowStrength));
				shadowcolor.rgb = ShiftHue(shadowcolor.rgb, DefaultIfZero(controllerHueShadowPost * 360, ShadowHuePostShift));
				
				ans += lerp(shadowcolor, Color, comp > DefaultIfZero(controllerThresholdToon, ToonThreshold) ? 1 : 0);
	        }
#ifdef MIKUMIKUMOVING
        }

        Color.rgb = ans/3;
#else
		Color.rgb = ans;
#endif
        //�t���O�������Ă��邩�v����
        if( transp ) Color.a = 0.5f;
    }
    
    Color.rgb = Color.rgb * DefaultIfZero(controllerMultiplyBase, BaseMultiplyValue) + DefaultIfZero(controllerAddBase, BaseAddValue);

    return Color; 
}

//==============================================
// �I�u�W�F�N�g�`��e�N�j�b�N
//==============================================

// �I�u�W�F�N�g�`��i�Z���t�V���h�EOFF�j
// �I�u�W�F�N�g�`��p�e�N�j�b�N�i�A�N�Z�T���p�j
technique MainTec0 < string MMDPass = "object"; bool UseToon = false; > {
#ifdef EDGE_FOR_ACCESSORIES
    pass DrawEdge {
        CullMode = CW;
        AlphaBlendEnable = FALSE;
        AlphaTestEnable  = FALSE;
        
        VertexShader = compile vs_2_0 Edge_VS();
        PixelShader  = compile ps_2_0 Edge_PS();
    }
#endif
    pass DrawObject {
    	CullMode = CCW;
    	AlphaBlendEnable = TRUE;
        AlphaTestEnable  = TRUE;
    	ZEnable = TRUE;
        VertexShader = compile vs_3_0 Basic_VS(false);
        PixelShader  = compile ps_3_0 Basic_PS(false);
    }
}

// �I�u�W�F�N�g�`��p�e�N�j�b�N�iPMD�APMX���f���p�j
technique MainTec2 < string MMDPass = "object"; bool UseToon = true; > {
    pass DrawObject {
    	ZEnable = TRUE;
        VertexShader = compile vs_3_0 Basic_VS(false);
        PixelShader  = compile ps_3_0 Basic_PS(false);
    }
}

// �I�u�W�F�N�g�`��i�Z���t�V���h�EON�j
// �I�u�W�F�N�g�`��p�e�N�j�b�N�i�A�N�Z�T���p�j
technique MainTec4 < string MMDPass = "object_ss"; bool UseToon = false; > {
#ifdef EDGE_FOR_ACCESSORIES
    pass DrawEdge {
        CullMode = CW;
        AlphaBlendEnable = FALSE;
        AlphaTestEnable  = FALSE;
        
        VertexShader = compile vs_2_0 Edge_VS();
        PixelShader  = compile ps_2_0 Edge_PS();
    }
#endif
    pass DrawObject {
    	CullMode = CCW;
    	AlphaBlendEnable = TRUE;
        AlphaTestEnable  = TRUE;
    	ZEnable = TRUE;
        VertexShader = compile vs_3_0 Basic_VS(true);
        PixelShader  = compile ps_3_0 Basic_PS(true);
    }
}

// �I�u�W�F�N�g�`��p�e�N�j�b�N�iPMD�APMX���f���p�j
technique MainTec6 < string MMDPass = "object_ss"; bool UseToon = true; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 Basic_VS(true);
        PixelShader  = compile ps_3_0 Basic_PS(true);
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////
