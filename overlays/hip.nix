self: super: {
  hip-clang = super.callPackage ./packages/hip.nix {
    inherit (super) rocm-device-libs rocm-thunk rocm-runtime rocminfo rocclr rocm-opencl-runtime rocm-comgr;
    inherit (super.llvmPackages_rocm) clang clang-unwrapped llvm compiler-rt lld;
  };
  hip = self.hip-clang;
}
