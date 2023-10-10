import numpy as np
import SimpleITK as sitk

def rmse(fixed,moving):
    if np.shape(fixed) == np.shape(moving):
        res = np.sqrt(np.square(np.subtract(fixed,moving)).mean())
        # print("fixed shape: ",np.shape(fixed)," /moving shape: ",np.shape(moving))
    # else:
    #     print("fixed and moving imgs must have same dimension!")

    return res

def dsc(fixed, moving):
    intersection = np.logical_and(fixed, moving).sum()
    union = fixed.sum() + moving.sum()

    if union == 0:
        return 0.0

    dsc = (2.0 * intersection) / union
    return dsc

def rda(FixMask_arr, MovedDose_arr, MovedMask_arr):

    msk_arr = np.array(FixMask_arr, np.uint8)

    ds_arr_regi = MovedDose_arr

    msk_arr_regi = np.array(MovedMask_arr, np.uint8)
    msk_arr_regi = np.where(msk_arr_regi > 0, 1, 0)

    dist = ds_arr_regi * msk_arr
    dist_regi = ds_arr_regi * msk_arr_regi

    dist = dist.flatten()
    dist = dist[dist != 0]
    dist_regi = dist_regi.flatten()
    dist_regi = dist_regi[dist_regi != 0]

    width = 0.1  # Gy
    bins = np.arange(0, max(dist) + width, width)
    volume, dose = np.histogram(dist, bins=bins)
    vol = np.flip(np.cumsum(np.flip(volume)))

    bins_regi = np.arange(0, max(dist_regi) + width, width)
    volume_regi, dose_regi = np.histogram(dist_regi, bins=bins_regi)
    vol_regi = np.flip(np.cumsum(np.flip(volume_regi)))

    if len(vol) > len(vol_regi):
        while len(vol) != len(vol_regi):
            vol_regi = np.append(vol_regi, 0)
    elif len(vol) < len(vol_regi):
        while len(vol) != len(vol_regi):
            vol = np.append(vol, 0)

    diff = sum(abs(vol - vol_regi))
    rda = diff / max(sum(vol), sum(vol_regi))
    return rda

def doo(FixedMask_arr,MovedDose_arr,MovedMask_arr):

    msk_arr = FixedMask_arr
    ds_arr_regi = MovedDose_arr
    msk_arr_regi = MovedMask_arr

    intersection = np.logical_and(msk_arr, msk_arr_regi)
    union = np.logical_or(msk_arr,msk_arr_regi)

    dist_int = ds_arr_regi * intersection
    dist_uni = ds_arr_regi * union

    doo = dist_int.sum() / dist_uni.sum()
    return doo


