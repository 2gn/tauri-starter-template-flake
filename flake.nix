{
  description = "flake template for tauri app development";

  outputs = { ... }: {
    templates.default = {
      path = ./tempaltes;
      description = "Default template";
    };
  }
}