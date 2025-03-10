module Business.MinswapV2.Utils where

import Business.MinswapV2.Constants (pbatcherFee, pdeposit)
import Plutarch.Api.V1 (PCurrencySymbol, PTokenName (PTokenName))
import Plutarch.Prelude

pcomputeLPAssetName ::
  Term s PCurrencySymbol ->
  Term s PTokenName ->
  Term s PCurrencySymbol ->
  Term s PTokenName ->
  Term s PTokenName
pcomputeLPAssetName assetAPolicyID assetATokenName assetBPolicyID assetBTokenName =
  let
    assetAImage = psha3_256 # (pto assetAPolicyID <> pto assetATokenName)
    assetBImage = psha3_256 # (pto assetBPolicyID <> pto assetBTokenName)
    aConcatB = assetAImage <> assetBImage
   in
    pcon $ PTokenName (psha3_256 # aConcatB)

plovelacesAfterFees :: Term s (PInteger :--> PInteger :--> PInteger :--> PInteger)
plovelacesAfterFees = plam $ \inputLovelaces routerFee routerOutRouterFee ->
  inputLovelaces - pbatcherFee - pdeposit - routerFee - routerOutRouterFee
