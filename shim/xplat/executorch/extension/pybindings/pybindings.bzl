load("@fbsource//xplat/executorch/build:runtime_wrapper.bzl", "runtime")

# Aten ops with portable kernel
MODELS_ATEN_OPS_LEAN_MODE_GENERATED_LIB = [
    "//executorch/kernels/portable:generated_lib",
]

PORTABLE_MODULE_DEPS = [
    "//executorch/runtime/kernel:operator_registry",
    "//executorch/runtime/executor:program",
    "//executorch/schema:bundled_program_schema",
    "//executorch/extension/aten_util:aten_bridge",
    "//executorch/util:bundled_program_verification",
    "//executorch/extension/data_loader:buffer_data_loader",
    "//executorch/extension/data_loader:mmap_data_loader",
    "//executorch/extension/memory_allocator:malloc_memory_allocator",
    "//executorch/util:util",
    "//executorch/runtime/executor/test:test_backend_compiler_lib",
] + ["//executorch/backends/xnnpack:xnnpack_backend"]

ATEN_MODULE_DEPS = [
    "//executorch/runtime/kernel:operator_registry",
    "//executorch/runtime/executor:program_aten",
    "//executorch/runtime/core/exec_aten:lib",
    "//executorch/schema:bundled_program_schema",
    "//executorch/extension/data_loader:buffer_data_loader",
    "//executorch/extension/data_loader:mmap_data_loader",
    "//executorch/extension/memory_allocator:malloc_memory_allocator",
    "//executorch/util:read_file",
    "//executorch/util:bundled_program_verification_aten",
    "//executorch/runtime/executor/test:test_backend_compiler_lib_aten",
]

# Generated lib for all ATen ops with aten kernel used by models in model inventory
MODELS_ATEN_OPS_ATEN_MODE_GENERATED_LIB = [
    "//executorch/kernels/quantized:generated_lib_aten",
    "//executorch/kernels/aten:generated_lib_aten",
]

def executorch_pybindings(python_module_name, srcs = [], cppdeps = [], visibility = ["//executorch/..."], types = [], compiler_flags = []):
    runtime.cxx_python_extension(
        name = python_module_name,
        srcs = [
            "//executorch/extension/pybindings:pybindings.cpp",
        ] + srcs,
        types = types,
        base_module = "executorch.extension.pybindings",
        compiler_flags = compiler_flags,
        preprocessor_flags = [
            "-DEXECUTORCH_PYTHON_MODULE_NAME={}".format(python_module_name),
        ],
        deps = [
            "//executorch/runtime/core:core",
            "//executorch/util:read_file",
        ] + cppdeps,
        external_deps = [
            "pybind11",
            "libtorch_python",
        ],
        use_static_deps = True,
        _is_external_target = bool(visibility != ["//executorch/..."]),
        visibility = visibility,
    )
