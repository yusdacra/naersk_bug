fn main() {
    prost_build::compile_protos(&["protocol/harmonytypes/v1/types.proto"], &["protocol/"]).expect("can't compile protos");
}
