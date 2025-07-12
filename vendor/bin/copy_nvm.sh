#!/system/bin/sh

# $1 src file
# $2 dst file
function copy_if_not_exist()
{
       if [ -f "${1}" ]; then
               nvmcp -n ${1} ${2}
               chmod 666 ${2}
               chown system.system ${2}
       fi
}

export PATH=$PATH:/system/bin
#copy audio calibration files to /NVM/ if not found.
copy_if_not_exist "/etc/audio_swvol_calibration.xml" "${NVM_ROOT_DIR}/audio_swvol_calibration.xml"
#use default file if audio_swvol_calibration.xml is absent.
copy_if_not_exist "/etc/audio_swvol_calibration_def.xml" "${NVM_ROOT_DIR}/audio_swvol_calibration.xml"
copy_if_not_exist "/etc/audio_gain_calibration.xml" "${NVM_ROOT_DIR}/audio_gain_calibration.xml"
copy_if_not_exist "/etc/audio_effect_config.xml" "${NVM_ROOT_DIR}/audio_effect_config.xml"
copy_if_not_exist "/etc/audio_MSAmain_ap.nvm" "${NVM_ROOT_DIR}/audio_MSAmain_ap.nvm"
copy_if_not_exist "/etc/audio_ec_ap.nvm" "${NVM_ROOT_DIR}/audio_ec_ap.nvm"
copy_if_not_exist "/etc/audio_ns_ap.nvm" "${NVM_ROOT_DIR}/audio_ns_ap.nvm"
copy_if_not_exist "/etc/audio_avc_ap.nvm" "${NVM_ROOT_DIR}/audio_avc_ap.nvm"
copy_if_not_exist "/etc/audio_HLPF_ap.nvm" "${NVM_ROOT_DIR}/audio_HLPF_ap.nvm"
copy_if_not_exist "/etc/audio_DualMic_ap.nvm" "${NVM_ROOT_DIR}/audio_DualMic_ap.nvm"
copy_if_not_exist "/etc/audio_eq_ap.nvm" "${NVM_ROOT_DIR}/audio_eq_ap.nvm"
copy_if_not_exist "/etc/audio_ctm_ap.nvm" "${NVM_ROOT_DIR}/audio_ctm_ap.nvm"
copy_if_not_exist "/etc/audio_MSAmain.nvm" "${NVM_ROOT_DIR}/audio_MSAmain.nvm"
copy_if_not_exist "/etc/audio_ec.nvm" "${NVM_ROOT_DIR}/audio_ec.nvm"
copy_if_not_exist "/etc/audio_ns.nvm" "${NVM_ROOT_DIR}/audio_ns.nvm"
copy_if_not_exist "/etc/audio_avc.nvm" "${NVM_ROOT_DIR}/audio_avc.nvm"
copy_if_not_exist "/etc/audio_HLPF.nvm" "${NVM_ROOT_DIR}/audio_HLPF.nvm"
copy_if_not_exist "/etc/audio_DualMic.nvm" "${NVM_ROOT_DIR}/audio_DualMic.nvm"
copy_if_not_exist "/etc/audio_eq.nvm" "${NVM_ROOT_DIR}/audio_eq.nvm"
copy_if_not_exist "/etc/audio_ctm.nvm" "${NVM_ROOT_DIR}/audio_ctm.nvm"
copy_if_not_exist "/etc/audio_config.nvm" "${NVM_ROOT_DIR}/audio_config.nvm"
copy_if_not_exist "/etc/audio_gssp_config.nvm" "${NVM_ROOT_DIR}/audio_gssp_config.nvm"
copy_if_not_exist "/etc/audio_misc.nvm" "${NVM_ROOT_DIR}/audio_misc.nvm"
copy_if_not_exist "/etc/audio_voice_calibration_ap.nvm" "${NVM_ROOT_DIR}/audio_voice_calibration_ap.nvm"
copy_if_not_exist "/etc/audio_voice_calibration.nvm" "${NVM_ROOT_DIR}/audio_voice_calibration.nvm"

if test "$(getprop ro.product.device)" = "pxa1L88FF"; then
/system/bin/update_nvm.sh
fi
