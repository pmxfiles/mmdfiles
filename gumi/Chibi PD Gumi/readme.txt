�@ _ �@��
(�@߁��)�c�@�g�D�[���I�g�D�[���I
�@���c

�Ƃ��������r�[���}��������Ă��ꂽ�B

��������g�D�[���V�F�[�_�[
�A�j���݂����Ƀo�L���Ɠh��ʂ���ꂽ�g�D�[���\���ł��B
���߂��₷���悤�ɐF���ݒ�ł���悤�ɂ��Ă����܂����B
(�����PMDEditor�Ńg�D�[���e�N�X�`���̐F��ύX����̂Ƃقړ����ł�)

�v���Z�b�g�Ƃ���

��.fx
��.fx
��.fx
��.fx

�������Ă��܂��B
���̒��Ŕ��Ɗ炾����������Ɠ���ŁA���ƕ��͐ݒ肪�Ⴄ�����̂��̂ł��B
���̓L���[�e�B�N���p�ɂ�����Ɖ��������Ă��銴���ł��B

������MMEffect���G�t�F�N�g���蓖�ẴE�C���h�E��main�^�u����A���f���̍ގ��ɓK�p���܂��B
�ʓ|�Ȑl�̓��f���ɕ�.fx�ł��K�p����΂����Ǝv����!!

��MultiEdge�ɂ���
���ɔz�z����Ă���G�t�F�N�g�ł����A���̃G�t�F�N�g�������ɓK�p���邱�Ƃŉ����������񂶂ɂȂ���������܂��B
MultiEdge.pmd��ǂݍ��񂾂��ƂɁAMultiEdge�\��.vmd��ǂݍ���ł݂Ă��������B

������ ����!! ������
�����G�t�F�N�g��M���Ă��Ȃ���Ԃł́A�z�z����̗얲�p�ɒ��߂���Ă��܂��B
���̂܂ܑ��̃��f���ɓK�p���Ă��u�Ȃ񂶂Ⴑ���[!!�v�ɂȂ�\���������ł��B
�f�G�ɂ������ꍇ�͎g���������f���p��fx���R�s�[���ĕҏW���Ďg���Ă��������B


���ݒ荀��
���ꂼ���fx�̐擪�����ɐݒ荀�ڂ������āA�F�����߂܂��B

float ShadowStrength = 1.1;
float3 ShadowBiasColor = float3(0.3, 0.3, 0.3);
float3 ShadowBiasColorAdd = float3(-0.15, -0.15, -0.15);
float3 BaseBiasColor = float3(0.7, 0.7, 0.7);
float3 BaseBiasColorAdd = float3(0.3, 0.3, 0.3);
float SpecularStrength = 7.5;

���̕�����

ShadowStrength:
�@�e�̐F�̔Z�������߂܂��B���O�̂��ɐ�����傫������Ɣ����Ȃ�܂��B
ShadowBiasColor:
�@�e�̐F�Ƃ��āA���̐F�ɏ�Z����F�����߂܂��B3�̐����͐ԁA�΁A��(�ȉ�����)�̐����ł��B
ShadowBiasColorAdd:
�@�e�̐F���グ����l�ł��B�v���X�Ȃ疾�邭�A�}�C�i�X�Ȃ�Â����銴���ł��B
BaseBiasColor:
�@�ގ��̌��̐F�ɏ�Z����F�����߂܂��B
BaseBiasColorAdd:
�@�ގ��̌��̐F���グ����l�ł��B
SpecularStrength:
�@����fx�ɂ̂ݓ����Ă���A�X�y�L�����̋��x�����߂�p�����[�^�[�ł��B

���ӂ���_�Ƃ��āAShadowBiasColorAdd�ABaseBiasColorAdd�ASpecularStrength�͑傫���l����ꂷ����Ɣ���т���\�����o�܂��B
SpecularStrength�ȊO�͊�{�I��0�`1�̐��������܂����A�������D���ɒ��߂��Ă��������BPC�����͂��܂���B�����炲�߂�Ȃ����B

�Ō�ɁA�f�G�ȃg�D�[�����C�t������܂��悤�ɁB
--
less.