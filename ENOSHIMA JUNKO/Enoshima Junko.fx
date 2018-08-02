////////////////////////////////////////////////////////////////////////////////////////////////
//  M4Toon.fx
//  Toon を二値化します
//  閾値以上の光沢 (加算スフィアマップ, スペキュラ) の色相シフト、任意の値の乗算および加算、適用率の指定ができます
//  影 (セルフシャドウ, トゥーン影) の色相シフト、任意の値の乗算および加算、適用率の指定ができます
//  アクセサリにエッジをつけます
//  作成: ミーフォ茜
//  
//  乗算と加算の色と値が同じ意味のものが二つあるのは MikuMikuMoving での指定の都合によるものです
//  
////////////////////////////////////////////////////////////////////////////////////////////////
//  改変元 SampleFull_v2_edge.fx
//
//  解説行を挿入
//  一部を結果が変わらないように変更
//  MMM独自のパラメータを追加。処理には無関係
//  針金P氏下記記載エフェクトを元にエッジ処理を追加

//  MikuMikuMoving_v0531_betaで動作確認
//  2012/04/16 更新
//  作成: beat32lop氏
//
////////////////////////////////////////////////////////////////////////////////////////////////
//  改変元 SampleBase.fxm
//  MikuMikuMoving用サンプルシェーダ
//  2012/03/17更新
//  作成: Mogg氏
//
////////////////////////////////////////////////////////////////////////////////////////////////
//  EdgeControl.fx ver0.0.3  エッジをMMDの標準シェーダを用いずに独自仕様で描画します
//  作成: 針金P氏( 舞力介入P氏のfull.fx改変 )

////////////////////////////////////////////////////////////////////////////////////////////////
// パラメータ宣言

// コントローラファイル名
#define CONTROLLER_NAME "M4ToonController.pmd"

// エッジをアクセサリに対しても描画するか (無効にする場合は文頭に // をつけて)
#define EDGE_FOR_ACCESSORIES

// アクセサリエッジ太さ
float EdgeThicknessMultiply = 0.75;

// 各種デフォルト値

float ToonThreshold
<
	string UIName = "トゥーン境界";
	string UIHelp = "Toon 適用を二値化する閾値を指定します。";
	string UIWidget = "Slider";
	float UIMin = 0;
	float UIMax = 1;
> = 0.5;
float ShadowStrength
<
	string UIName = "影濃度";
	string UIHelp = "影の濃さを指定します。";
	string UIWidget = "Slider";
	float UIMin = 0;
	float UIMax = 1;
> = 0.7;
float SpecularStrength
<
	string UIName = "光沢濃度";
	string UIHelp = "光沢 (加算スフィアマップ/スペキュラ) の濃さを指定します。";
	string UIWidget = "Slider";
	float UIMin = 0;
	float UIMax = 1;
> = 1.5;
float SphereStrength
<
	string UIName = "乗算スフィア濃度";
	string UIHelp = "乗算スフィアマップの濃さを指定します。";
	string UIWidget = "Slider";
	float UIMin = 0;
	float UIMax = 1;
> = 0.75;
float SpherePower
<
	string UIName = "スフィア強度";
	string UIHelp = "スフィアマップの強調度を指定します。";
	string UIWidget = "Slider";
	float UIMin = 0;
	float UIMax = 1;
> = 0;

float BaseMultiplyValue
<
	string UIName = "全体乗算値";
	string UIHelp = "全体に乗算する値を指定します。";
	string UIWidget = "Slider";
	float UIMin = -2;
	float UIMax = 2;
> = 0.9;
float BaseAddValue
<
	string UIName = "全体加算値";
	string UIHelp = "全体に乗算する値を指定します。";
	string UIWidget = "Slider";
	float UIMin = -2;
	float UIMax = 2;
> = 0.12;

float SpecularThreshold
<
	string UIName = "光沢操作閾値";
	string UIHelp = "光沢を色調変更する最低基準値を各色の平均値で指定します。";
	string UIWidget = "Slider";
	float UIMin = 0;
	float UIMax = 1;
> = 0.2;
float3 LowerSpecularMultiplyValue
<
	string UIName = "弱光沢乗算値";
	string UIHelp = "閾値に満たない光沢に乗算する値を指定します。";
	string UIWidget = "Slider";
	float3 UIMin = -2;
	float3 UIMax = 2;
> = 0;
float3 SpecularMultiplyColor
<
	string UIName = "光沢乗算色";
	string UIHelp = "光沢に乗算する色を指定します。";
	string UIWidget = "Color";
> = float3(1, 1, 1);
float3 SpecularMultiplyValue
<
	string UIName = "光沢乗算値";
	string UIHelp = "光沢に乗算する値を指定します。";
	string UIWidget = "Slider";
	float3 UIMin = -2;
	float3 UIMax = 2;
> = float3(1.25, 1.25, 1.25);
float3 SpecularAddColor
<
	string UIName = "光沢加算色";
	string UIHelp = "光沢に加算する色を指定します。";
	string UIWidget = "Color";
> = float3(0, 0, 0);
float3 SpecularAddValue
<
	string UIName = "光沢加算値";
	string UIHelp = "光沢に加算する値を指定します。";
	string UIWidget = "Slider";
	float3 UIMin = -2;
	float3 UIMax = 2;
> = float3(0, 0, 0);

float3 ShadowMultiplyColor
<
	string UIName = "影乗算色";
	string UIHelp = "影に乗算する色を指定します。";
	string UIWidget = "Color";
> = float3(1, 0.9, 0.8);
float3 ShadowMultiplyValue
<
	string UIName = "影乗算値";
	string UIHelp = "影に乗算する値を指定します。";
	string UIWidget = "Slider";
	float3 UIMin = -2;
	float3 UIMax = 2;
> = float3(1, 1, 1);
float3 ShadowAddColor
<
	string UIName = "影加算色";
	string UIHelp = "陰に加算する色を指定します。";
	string UIWidget = "Color";
> = float3(0, 0, 0);
float3 ShadowAddValue
<
	string UIName = "影加算値";
	string UIHelp = "影に加算する値を指定します。";
	string UIWidget = "Slider";
	float3 UIMin = -2;
	float3 UIMax = 2;
> = float3(0, 0, 0);

float SpecularHuePreShift
<
	string UIName = "光沢相事前シフト";
	string UIHelp = "光沢の色相をシフトする値をディグリーで指定します。";
	string UIWidget = "Slider";
	float UIMin = -180;
	float UIMax = 180;
> = 0;
float SpecularHuePostShift
<
	string UIName = "光沢相事後シフト";
	string UIHelp = "光沢の色相をシフトする値をディグリーで指定します。";
	string UIWidget = "Slider";
	float UIMin = -180;
	float UIMax = 180;
> = 0;
float ShadowHuePreShift
<
	string UIName = "影色相事前シフト";
	string UIHelp = "影の色相をシフトする値をディグリーで指定します。";
	string UIWidget = "Slider";
	float UIMin = -180;
	float UIMax = 180;
> = -20;
float ShadowHuePostShift
<
	string UIName = "影色相事後シフト";
	string UIHelp = "影の色相をシフトする値をディグリーで指定します。";
	string UIWidget = "Slider";
	float UIMin = -180;
	float UIMax = 180;
> = 0;

////////////////////////////////////////////////////////////////////////////////////////////////

bool controllerVisible : CONTROLOBJECT < string name = CONTROLLER_NAME; >;
float controllerThresholdToon : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "トゥーン境界"; >;
float controllerStrengthSpecular : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "光沢濃度"; >;
float controllerStrengthShadow : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "影濃度"; >;
float controllerStrengthSphere : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "スフィア濃度"; >;
float controllerPowerSphere : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "スフィア強度"; >;
float controllerThresholdSpecular : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "光沢閾値"; >;
float controllerMultiplyBase : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "乗算全体"; >;
float controllerAddBase : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "加算全体"; >;
float controllerMultiplyLowerSpecularR : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "R乗算弱光沢"; >;
float controllerMultiplyLowerSpecularG : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "G乗算弱光沢"; >;
float controllerMultiplyLowerSpecularB : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "B乗算弱光沢"; >;
float controllerMultiplySpecularR : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "R乗算光沢"; >;
float controllerMultiplySpecularG : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "G乗算光沢"; >;
float controllerMultiplySpecularB : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "B乗算光沢"; >;
float controllerAddSpecularR : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "R加算光沢"; >;
float controllerAddSpecularG : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "G加算光沢"; >;
float controllerAddSpecularB : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "B加算光沢"; >;
float controllerMultiplyShadowR : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "R乗算影"; >;
float controllerMultiplyShadowG : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "G乗算影"; >;
float controllerMultiplyShadowB : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "B乗算影"; >;
float controllerAddShadowR : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "R加算影"; >;
float controllerAddShadowG : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "G加算影"; >;
float controllerAddShadowB : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "B加算影"; >;
float controllerHueSpecularPre : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "色相前光沢"; >;
float controllerHueSpecularPost : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "色相後光沢"; >;
float controllerHueShadowPre : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "色相前影"; >;
float controllerHueShadowPost : CONTROLOBJECT < string name = CONTROLLER_NAME; string item = "色相後影"; >;

//座法変換行列
float4x4 WorldViewProjMatrix      : WORLDVIEWPROJECTION;
float4x4 WorldMatrix              : WORLD;
float4x4 ViewMatrix               : VIEW;

//エッジ用に追加
float4x4 ProjMatrix               : PROJECTION;
float4x4 ViewProjMatrix           : VIEWPROJECTION;

//カメラ位置
float3   CameraPosition    : POSITION  < string Object = "Camera"; >;

// マテリアル色
float4   MaterialDiffuse   : DIFFUSE  < string Object = "Geometry"; >;
//static float4   MaterialDiffuse = float4(0,0,0,1);
float3   MaterialAmbient   : AMBIENT  < string Object = "Geometry"; >;
//static float3   MaterialAmbient = MaterialDiffuse.rgb;
float3   MaterialEmmisive  : EMISSIVE < string Object = "Geometry"; >;
float3   MaterialSpecular  : SPECULAR < string Object = "Geometry"; >;
float    SpecularPower     : SPECULARPOWER < string Object = "Geometry"; >;
float3   MaterialToon      : TOONCOLOR;

//エッジ色とエッジ太さ
float3   EdgeColor         : EDGECOLOR < string Object = "Geometry"; >;
float    EdgeWidth         : EDGEWIDTH < string Object = "Geometry"; >;


// ライト色
float3   LightDiffuse      : DIFFUSE   < string Object = "Light"; >;
float3   LightAmbient      : AMBIENT   < string Object = "Light"; >;
float3   LightSpecular     : SPECULAR  < string Object = "Light"; >;

// MME用のパラメータ
#ifndef MIKUMIKUMOVING

float4x4 LightWorldViewProjMatrix : WORLDVIEWPROJECTION < string Object = "Light"; >;
float3   LightDirection0    : DIRECTION < string Object = "Light"; >;

// 互換用に再定義
static float3   LightDirection[1] = {LightDirection0};
static float3   LightDiffuses [3] = {LightDiffuse, LightDiffuse, LightDiffuse};
static float3   LightAmbients [3] = {LightAmbient, LightAmbient, LightAmbient};
static float3   LightSpeculars[3] = {LightSpecular, LightSpecular, LightSpecular};

//材質モーフ関連
float4	 AddingTexture   = (0,0,0,0);
float4	 AddingSphere    = (0,0,0,0);
float4	 MultiplyTexture = (1,1,1,1);
float4	 MultiplySphere  = (1,1,1,1);

static float MMM_LightCount = 1;
static bool  LightEnables[3] = {true, false, false};		// 有効フラグ


#else

//ライト関連
//新しく追加されたフラグ
bool	 LightEnables[MMM_LightCount]		: LIGHTENABLES;		// 有効フラグ
//座法変換行列からこちらに移動した。[]はライトの番号で、デフォルトだと0、1、2のどれか
float4x4 LightWVPMatrices[MMM_LightCount]	: LIGHTWVPMATRICES;	// 座標変換行列
float3   LightDirection[MMM_LightCount]		: LIGHTDIRECTIONS;	// 方向

//こちらも新しく追加されたもの
//材質モーフ関連
float4	 AddingTexture		  : ADDINGTEXTURE;	// 材質モーフ加算Texture値
float4	 AddingSphere		  : ADDINGSPHERE;	// 材質モーフ加算SphereTexture値
float4	 MultiplyTexture	  : MULTIPLYINGTEXTURE;	// 材質モーフ乗算Texture値
float4	 MultiplySphere		  : MULTIPLYINGSPHERE;	// 材質モーフ乗算SphereTexture値

//処理が変更されたセルフシャドウの計算に使用
//影の濃さ
float	 ShadowDeepPositive       : SHADOWDEEP_POSITIVE;
float	 ShadowDeepNegative       : SHADOWDEEP_NEGATIVE;
float	 ShadowDeep               : SHADOWDEEP;	// 通常の濃さ

//それぞれ3つのライトに割り当てられている
// ライト色
float3   LightDiffuses[MMM_LightCount]      : LIGHTDIFFUSECOLORS;
float3   LightAmbients[MMM_LightCount]      : LIGHTAMBIENTCOLORS;
float3   LightSpeculars[MMM_LightCount]     : LIGHTSPECULARCOLORS;

#endif


// ライト色
//ライトが３つに増えたので、それにともなってこちらも３つになった
static float4 DiffuseColor[3]  = { MaterialDiffuse * float4(LightDiffuses[0], 1.0f)
				 , MaterialDiffuse * float4(LightDiffuses[1], 1.0f)
				 , MaterialDiffuse * float4(LightDiffuses[2], 1.0f)};
static float3 AmbientColor[3]  = { saturate(MaterialAmbient * LightAmbients[0] + MaterialEmmisive)
				 , saturate(MaterialAmbient * LightAmbients[1] + MaterialEmmisive)
				 , saturate(MaterialAmbient * LightAmbients[2] + MaterialEmmisive)};
static float3 SpecularColor[3] = { MaterialSpecular * LightSpeculars[0]
				 , MaterialSpecular * LightSpeculars[1]
				 , MaterialSpecular * LightSpeculars[2]};

bool     parthf;   // パースペクティブフラグ
bool	use_texture;		// テクスチャ使用
bool	use_spheremap;		// スフィアマップ使用
bool	use_toon;			// トゥーン描画かどうか (アクセサリ: false, モデル: true)
bool	transp;				// 半透明フラグ
bool	spadd;				// スフィアマップ加算合成フラグ
#define SKII1    1500
#define SKII2    8000
#define Toon     3

// オブジェクトのテクスチャ
texture ObjectTexture: MATERIALTEXTURE;
sampler ObjTexSampler = sampler_state {
    texture = <ObjectTexture>;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};

// スフィアマップのテクスチャ
texture ObjectSphereMap: MATERIALSPHEREMAP;
sampler ObjSphareSampler = sampler_state {
    texture = <ObjectSphereMap>;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};


#ifndef MIKUMIKUMOVING

// MMD本来のsamplerを上書きしないための記述です。削除不可。
sampler MMDSamp0 : register(s0);
sampler MMDSamp1 : register(s1);
sampler MMDSamp2 : register(s2);

#else

bool    usetoontexturemap;

#endif

///////////////////////////////////////////////////////////////////////////////////////////////
// 輪郭描画（エッジ）
// 頂点シェーダ(描画用)

#ifdef MIKUMIKUMOVING

float4 Edge_VS(MMM_SKINNING_INPUT IN) : POSITION
{
    //================================================================================
    //MikuMikuMoving独自のスキニング関数(MMM_SkinnedPositionNormal)。座標と法線を取得する。
    //================================================================================
    MMM_SKINNING_OUTPUT SkinOut = MMM_SkinnedPositionNormal(IN.Pos, IN.Normal, IN.BlendWeight, IN.BlendIndices, IN.SdefC, IN.SdefR0, IN.SdefR1);
    // ワールド座標変換
    float4 Pos = mul( SkinOut.Position, WorldMatrix );
    float3 Normal = normalize( mul( SkinOut.Normal, (float3x3)WorldMatrix ) );
    
//  IN.EdgeWeightでモデルのエッジ太さを取得
//    float EdgeThickness = IN.EdgeWeight *0.5 *ThicknessRate;
//  追加された機能EdgeWidthを試す。モデルプロパティのエッジ太さを取得している？
//    float EdgeThickness = EdgeWidth * 1000;
//  モデルのエッジ太さ×モデルプロパティのエッジ太さ
//    float EdgeThickness = IN.EdgeWeight * EdgeWidth * 1000 *ThicknessRate;
    float EdgeThickness = (use_toon ? IN.EdgeWeight * EdgeWidth * 1000 : 1) * EdgeThicknessMultiply;

    // カメラとの距離
    float len = max( length( CameraPosition - Pos ), 5.0f );

    // 頂点を法線方向に押し出す
    Pos.xyz += Normal * ( len * EdgeThickness * 0.0015f * pow(2.4142f / ProjMatrix._22, 0.7f) );

    // カメラ視点のビュー射影変換
    Pos = mul( Pos, ViewProjMatrix );

    return Pos;
}

#else
float4 Edge_VS(float4 Pos : POSITION, float3 Normal : NORMAL) : POSITION
{
	float EdgeThickness = 1.0f * EdgeThicknessMultiply;

    // ワールド座標変換
    Pos = mul( Pos, WorldMatrix );
    Normal = normalize( mul( Normal, (float3x3)WorldMatrix ) );

    // カメラとの距離
    float len = max( length( CameraPosition - Pos ), 5.0f );

    // 頂点を法線方向に押し出す
    Pos.xyz += Normal * ( len * EdgeThickness * 0.0015f * pow(2.4142f / ProjMatrix._22, 0.7f) );

    // カメラ視点のビュー射影変換
    Pos = mul( Pos, ViewProjMatrix );

    return Pos;
}
#endif


// ピクセルシェーダ(描画用)
float4 Edge_PS() : COLOR
{
    // 輪郭色で塗りつぶし
    return saturate ( float4( EdgeColor,1));
    
}
///////////////////////////////////////////////////////////////////////////////////////////////
// 輪郭描画用テクニック

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
// セルフシャドウ用Z値プロット

#ifndef MIKUMIKUMOVING

struct VS_ZValuePlot_OUTPUT {
    float4 Pos : POSITION;              // 射影変換座標
    float4 ShadowMapTex : TEXCOORD0;    // Zバッファテクスチャ
};

// 頂点シェーダ
VS_ZValuePlot_OUTPUT ZValuePlot_VS( float4 Pos : POSITION )
{
    VS_ZValuePlot_OUTPUT Out = (VS_ZValuePlot_OUTPUT)0;

    // ライトの目線によるワールドビュー射影変換をする
    Out.Pos = mul( Pos, LightWorldViewProjMatrix );

    // テクスチャ座標を頂点に合わせる
    Out.ShadowMapTex = Out.Pos;

    return Out;
}
// ピクセルシェーダ
float4 ZValuePlot_PS( float4 ShadowMapTex : TEXCOORD0 ) : COLOR
{
    // R色成分にZ値を記録する
    return float4(ShadowMapTex.z/ShadowMapTex.w,0,0,1);
}

// Z値プロット用テクニック
// MMMではstring MMDPass = "zplot"; が無視されていると思う
technique ZplotTec < string MMDPass = "zplot"; > {
    pass ZValuePlot {
        AlphaBlendEnable = FALSE;
        VertexShader = compile vs_2_0 ZValuePlot_VS();
        PixelShader  = compile ps_2_0 ZValuePlot_PS();
    }
}


// シャドウバッファのサンプラ。"register(s0)"なのはMMDがs0を使っているから
sampler DefSampler : register(s0);

#endif

///////////////////////////////////////////////////////////////////////////////////////////////
// オブジェクト描画（セルフシャドウON/OFF共通）


//  変更箇所は項目の追加なので、特に問題なく使える
struct VS_OUTPUT {
    float4 Pos        : POSITION;    // 射影変換座標
    float4 ZCalcTex : TEXCOORD0;    // Z値
    float2 Tex        : TEXCOORD1;   // テクスチャ
    float3 Normal     : TEXCOORD2;   // 法線
    float3 Eye        : TEXCOORD3;   // カメラとの相対位置
    float2 SpTex      : TEXCOORD4;   // スフィアマップテクスチャ座標
    // MME側のZCalcTexの代わりに使う
    float4 SS_UV1     : TEXCOORD5;   // セルフシャドウテクスチャ座標
    float4 SS_UV2     : TEXCOORD6;   // セルフシャドウテクスチャ座標
    float4 SS_UV3     : TEXCOORD7;   // セルフシャドウテクスチャ座標
    float4 Color      : COLOR0;      // ディフューズ色
};

//** 色相シフト
// shift は -360～360
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

//** a が 0 なら b
float DefaultIfZero(float a, float b)
{
	return !controllerVisible && a == 0 ? b : a;
}
float3 DefaultIfZero3(float3 a, float3 b)
{
	return !controllerVisible && a == 0 ? b : a;
}

// かなり気持ち悪いところで分岐しますので注意
#ifdef MIKUMIKUMOVING
//==============================================
// 頂点シェーダ
// MikuMikuMoving独自の頂点シェーダ入力(MMM_SKINNING_INPUT)
//==============================================
//  セルフシャドウフラグの uniform bool useSelfShadow が追加されている
VS_OUTPUT Basic_VS(MMM_SKINNING_INPUT IN, uniform bool useSelfShadow)
{
    
    //================================================================================
    //MikuMikuMoving独自のスキニング関数(MMM_SkinnedPositionNormal)。座標と法線を取得する。
    //================================================================================
    MMM_SKINNING_OUTPUT SkinOut = MMM_SkinnedPositionNormal(IN.Pos, IN.Normal, IN.BlendWeight, IN.BlendIndices, IN.SdefC, IN.SdefR0, IN.SdefR1);
    float4 Pos = SkinOut.Position;
    float3 Normal = SkinOut.Normal;
    float2 Tex = IN.Tex;
    // ↑ fx側の記述に合わせた。以下、fxの処理をコピペすれば対応できるかも。
    

// MME用
// 頂点シェーダ
#else
// uniform bool useSelfShadowを追加
VS_OUTPUT Basic_VS(float4 Pos : POSITION, float3 Normal : NORMAL, float2 Tex : TEXCOORD0, uniform bool useSelfShadow)
{
#endif
    
    VS_OUTPUT Out = (VS_OUTPUT)0;
    
    // 頂点座標
    Out.Pos = mul(Pos, WorldViewProjMatrix);
    // 頂点法線
    Out.Normal = normalize( mul( Normal, (float3x3)WorldMatrix ) );
    // カメラとの相対位置
    Out.Eye = CameraPosition - mul(Pos, WorldMatrix);
    
    // ディフューズ色＋アンビエント色 計算
//    Out.Color.rgb = AmbientColor[0];
    // 色を計算
    float3 color = float3(0, 0, 0);
    float count = 0;

//  Lightの計算。数以外はMMDと変わらず
//  コピペするときは差し替えないように注意。差し替えると照明1しか効かなくなる
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
    
    // テクスチャ座標
    Out.Tex = Tex;
    
    if (use_spheremap) {
        // スフィアマップテクスチャ座標
        float2 NormalWV = mul(Out.Normal, (float3x3)ViewMatrix);
        Out.SpTex.x = NormalWV.x * 0.5f + 0.5f;
        Out.SpTex.y = NormalWV.y * -0.5f + 0.5f;
    }

#ifdef MIKUMIKUMOVING
//  セルフシャドウは変更された
    if (useSelfShadow)
    {
        //セルフシャドウデプスマップテクスチャ座標を計算
        float4 dpos = mul(Pos, WorldMatrix);
        // ライト視点によるワールドビュー射影変換
        Out.SS_UV1 = mul(dpos, LightWVPMatrices[0]);
        Out.SS_UV2 = mul(dpos, LightWVPMatrices[1]);
        Out.SS_UV3 = mul(dpos, LightWVPMatrices[2]);
    }
    
// 必要なのは1だけだが、処理互換用にMME側でも作っておく
#else
	// ライト視点によるワールドビュー射影変換
    Out.SS_UV1 = mul( Pos, LightWorldViewProjMatrix );
#endif
    
    return Out;
}

//==============================================
// ピクセルシェーダ
// 入力は特に独自形式なし
//==============================================
float4 Basic_PS(VS_OUTPUT IN, uniform bool useSelfShadow) : COLOR0
{
	//** Toon 非使用箇所に影を付けない
	if (use_toon)
	#ifndef MIKUMIKUMOVING
		use_toon = MaterialToon != float3(1, 1, 1);
	#else
		use_toon = usetoontexturemap;
	#endif
	
    // スペキュラ色計算(ライト0のみ反映)
    float3 HalfVector = normalize(normalize(IN.Eye) + -LightDirection[0]);
    float3 Specular = pow(max(0,dot( HalfVector, normalize(IN.Normal))), SpecularPower) * SpecularColor[0];
    
    float4 Color = IN.Color;
    float4 ShadowColor = float4(AmbientColor[0], Color.a);  // 影の色
    float4 texColor = float4(1, 1, 1, 1);
    float  texAlpha = MultiplyTexture.a + AddingTexture.a;
    if (use_texture) {
        // テクスチャ適用
        texColor = tex2D(ObjTexSampler, IN.Tex);
        texColor.rgb = (texColor.rgb * MultiplyTexture.rgb + AddingTexture.rgb) * texAlpha + (1.0 - texAlpha);
    }
    
    // 処理を１行に統合
    Color *= texColor;
    ShadowColor *= texColor;

	//** ベース色保存
	float3 baseColor = Color.rgb;

    if (use_spheremap)
    {
        float sp = DefaultIfZero(controllerPowerSphere, SpherePower);
        float4 stex = tex2D(ObjSphareSampler,IN.SpTex);
    	
    	//** スフィアマップ強調
        stex.rgb = lerp(stex.rgb, max(pow(stex.rgb, 16), 0) * 10, sp);
        
        // スフィアマップ適用
        if(spadd)
        {
        	Color.rgb += stex.rgb;
        	ShadowColor.rgb += stex.rgb;
        } else {
        	float ss = DefaultIfZero(controllerStrengthSphere, SphereStrength);
        	
        	//** 乗算スフィアの場合、適用率を適用しベース色更新
        	Color.rgb = lerp(Color.rgb, Color.rgb * stex.rgb, ss);
        	ShadowColor.rgb = lerp(ShadowColor.rgb, ShadowColor.rgb * stex.rgb, ss);
        	baseColor = Color.rgb;
        }
    }
    
    //Toonの色(ライト0のみ反映)
    //分岐の有無にかかわらず利用するのでここに移動
    float LightNormal = dot( IN.Normal, -LightDirection[0] );
    float3 shadow = lerp(MaterialToon, float3(1,1,1), saturate(LightNormal * 16 + 0.5));
    
    if (!useSelfShadow && use_toon) {
        // トゥーン適用
        Color.rgb *= shadow;
        
        //** TODO:ここにも影変色入れるべきなんだけど面倒いので非対応
        baseColor *= shadow;
    }
    
    // full.fxに合わせてこの位置で
    // スペキュラ適用
    Color.rgb += Specular;

	//** 考えるのも面倒なので光沢合成し直し
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

// 処理が変わったセルフシャドウ
    //セルフシャドウ
    if (useSelfShadow && use_toon)
    {
        float smz, comp, tt, count;
        float2 texcoord;
        float3 color = float3(1,1,1);
        //  色保存用
        float4 ans = float4(0,0,0,0);
        float4 d;
        float4 uv[3];
        uv[0] = IN.SS_UV1;
        uv[1] = IN.SS_UV2;
        uv[2] = IN.SS_UV3;

        //セルフシャドウ色を計算
#ifdef MIKUMIKUMOVING
        for (int i = 0; i < 3; i++)
        {
#endif

#ifdef MIKUMIKUMOVING
            tt = uv[i].z;
            // テクスチャ座標に変換
            texcoord = float2(1.0f + uv[i].x / uv[i].w, 1.0f - uv[i].y / uv[i].w) * 0.5f;

            //================================================================================
            // MikuMikuMoving独自の深度情報取得関数(MMM_UnpackDepth)
            //================================================================================
            d = tex2D(MMM_SelfShadowSampler[i], texcoord);
            // d.xだと比較演算できないのでMMM_UnpackDepth()が必要？
            // また、MMM_UnpackDepth()の時点でMMDと計算が異なっている?
            // 右辺に数値を足すのはジャギー対策。大きくすれば影が小さくなる
            smz = MMM_UnpackDepth(d) + 0.0001;
            if (tt > smz)
            {
                //色の濃さを計算
                // セルフシャドウ mode1
//                comp = 1.0 - saturate( (tt - smz) * SKII1 -0.3f);
                // セルフシャドウ mode2に相当してるかも
                comp = 1.0 - saturate( (tt - smz) * SKII2 *ShadowDeep -0.3f);
            }
            
//MME用処理
#else
            // テクスチャ座標に変換
            uv[0] = IN.SS_UV1;
            uv[0] /= uv[0].w;
            float2 TransTexCoord;
            TransTexCoord.x = (1.0f + uv[0].x)*0.5f;
            TransTexCoord.y = (1.0f - uv[0].y)*0.5f;
            if( any( saturate(TransTexCoord) != TransTexCoord ) ) {
                // シャドウバッファ外
                use_toon = false;
                ans = Color;
            } else {
                if(parthf) {
                // セルフシャドウ mode2
                   comp=1-saturate(max(uv[0].z-tex2D(DefSampler,TransTexCoord).r , 0.0f)*SKII2*TransTexCoord.y-0.3f);
                } else {
                // セルフシャドウ mode1
                   comp=1-saturate(max(uv[0].z-tex2D(DefSampler,TransTexCoord).r , 0.0f)*SKII1-0.3f);
                }
            }
  
#endif
            
            
            // ループ対策
            float4 shadowcolor = Color;
//            float4 shadowcolor;
            
            if ( use_toon ) {
            // トゥーン適用
	            comp = min(saturate(LightNormal*Toon),comp);
	            shadowcolor.rgb = ShadowColor.rgb *MaterialToon;
	        //ans += lerp(shadowcolor, Color, comp);
	        
				//**トゥーン色分け
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
        //フラグが生きているか要検証
        if( transp ) Color.a = 0.5f;
    }
    
    Color.rgb = Color.rgb * DefaultIfZero(controllerMultiplyBase, BaseMultiplyValue) + DefaultIfZero(controllerAddBase, BaseAddValue);

    return Color; 
}

//==============================================
// オブジェクト描画テクニック
//==============================================

// オブジェクト描画（セルフシャドウOFF）
// オブジェクト描画用テクニック（アクセサリ用）
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

// オブジェクト描画用テクニック（PMD、PMXモデル用）
technique MainTec2 < string MMDPass = "object"; bool UseToon = true; > {
    pass DrawObject {
    	ZEnable = TRUE;
        VertexShader = compile vs_3_0 Basic_VS(false);
        PixelShader  = compile ps_3_0 Basic_PS(false);
    }
}

// オブジェクト描画（セルフシャドウON）
// オブジェクト描画用テクニック（アクセサリ用）
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

// オブジェクト描画用テクニック（PMD、PMXモデル用）
technique MainTec6 < string MMDPass = "object_ss"; bool UseToon = true; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 Basic_VS(true);
        PixelShader  = compile ps_3_0 Basic_PS(true);
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////
