return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.4",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 15,
  height = 30,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 6,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "snowmountain",
      firstgid = 1,
      filename = "snowmountain.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "snowWIP.png",
      imagewidth = 512,
      imageheight = 512,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 256,
      tiles = {
        {
          id = 0,
          type = "solid"
        },
        {
          id = 116,
          type = "solid"
        }
      }
    },
    {
      name = "base_out_atlas",
      firstgid = 257,
      filename = "base_out_atlas.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 32,
      image = "base_out_atlas.png",
      imagewidth = 1024,
      imageheight = 1024,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 1024,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 1,
      name = "background",
      x = 0,
      y = 0,
      width = 15,
      height = 30,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        11, 12, 90, 87, 95, 96, 96, 96, 96, 96, 96, 96, 88, 89, 13,
        27, 28, 29, 110, 111, 112, 112, 112, 112, 112, 94, 95, 96, 28, 29,
        43, 44, 45, 14, 127, 128, 128, 128, 128, 128, 110, 111, 112, 44, 45,
        11, 12, 13, 11, 94, 94, 94, 94, 110, 126, 126, 127, 128, 12, 13,
        27, 28, 29, 94, 110, 110, 110, 110, 126, 126, 127, 128, 27, 28, 29,
        43, 44, 94, 110, 126, 126, 126, 126, 126, 127, 128, 45, 43, 44, 45,
        11, 12, 110, 27, 126, 127, 128, 29, 29, 11, 12, 13, 11, 12, 13,
        27, 28, 126, 126, 127, 128, 111, 28, 29, 27, 28, 29, 27, 28, 29,
        43, 44, 126, 127, 128, 128, 96, 96, 45, 43, 44, 45, 43, 44, 45,
        11, 12, 126, 126, 127, 128, 112, 112, 96, 96, 12, 13, 11, 12, 13,
        27, 28, 29, 126, 127, 128, 128, 128, 112, 112, 96, 96, 27, 28, 29,
        43, 44, 45, 43, 44, 126, 127, 128, 128, 128, 112, 112, 96, 44, 45,
        11, 12, 13, 11, 12, 13, 11, 126, 127, 128, 128, 27, 112, 12, 13,
        27, 28, 29, 27, 28, 29, 27, 28, 29, 126, 127, 128, 128, 28, 29,
        43, 44, 45, 43, 44, 45, 43, 44, 45, 94, 126, 127, 128, 44, 45,
        11, 12, 13, 11, 12, 13, 11, 12, 13, 110, 126, 127, 128, 12, 13,
        27, 28, 29, 27, 28, 29, 27, 28, 94, 126, 126, 127, 128, 28, 29,
        43, 44, 45, 43, 44, 45, 43, 44, 110, 126, 127, 128, 14, 44, 45,
        11, 12, 13, 11, 12, 13, 11, 12, 126, 126, 127, 128, 11, 12, 13,
        27, 28, 29, 27, 28, 94, 94, 94, 126, 127, 128, 93, 27, 28, 29,
        43, 44, 45, 43, 44, 110, 110, 110, 126, 127, 128, 96, 43, 44, 45,
        11, 12, 13, 11, 94, 126, 126, 126, 126, 127, 128, 94, 95, 96, 13,
        27, 94, 94, 94, 110, 126, 127, 128, 110, 110, 110, 94, 95, 96, 29,
        43, 110, 110, 110, 126, 126, 126, 126, 126, 94, 95, 27, 96, 96, 45,
        11, 126, 126, 126, 126, 127, 128, 96, 96, 110, 111, 112, 112, 96, 13,
        27, 28, 126, 127, 128, 128, 128, 112, 112, 126, 127, 128, 128, 112, 29,
        43, 44, 45, 43, 44, 126, 127, 128, 128, 43, 126, 127, 128, 128, 45,
        11, 12, 13, 11, 12, 13, 126, 127, 128, 45, 12, 13, 11, 12, 13,
        27, 28, 29, 27, 28, 29, 126, 127, 128, 27, 28, 29, 27, 28, 29,
        43, 44, 45, 43, 44, 45, 126, 127, 128, 43, 44, 45, 43, 44, 45
      }
    },
    {
      type = "tilelayer",
      id = 2,
      name = "edges",
      x = 0,
      y = 0,
      width = 15,
      height = 30,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 85, 0, 0, 0, 0, 0, 0, 0, 0, 0, 61, 48, 0,
        0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64, 0,
        0, 0, 78, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64, 0,
        0, 0, 46, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64, 0,
        0, 46, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 77, 80, 0,
        0, 62, 124, 175, 125, 0, 0, 0, 0, 0, 0, 77, 80, 0, 0,
        0, 62, 160, 0, 158, 0, 0, 77, 79, 79, 79, 80, 0, 0, 0,
        0, 62, 140, 143, 141, 0, 0, 61, 48, 0, 0, 0, 0, 0, 0,
        0, 62, 0, 0, 0, 0, 0, 0, 61, 47, 48, 0, 0, 0, 0,
        0, 62, 0, 0, 0, 0, 0, 0, 0, 0, 61, 47, 48, 0, 0,
        0, 78, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 61, 48, 0,
        0, 0, 78, 79, 76, 0, 0, 0, 0, 0, 124, 175, 125, 64, 0,
        0, 0, 0, 0, 78, 79, 76, 0, 0, 0, 160, 0, 158, 64, 0,
        0, 0, 0, 0, 0, 0, 78, 79, 76, 0, 140, 143, 141, 64, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 64, 0,
        0, 0, 0, 0, 0, 0, 0, 46, 60, 0, 0, 0, 0, 64, 0,
        0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 64, 0,
        0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 77, 80, 0,
        0, 0, 0, 0, 46, 47, 47, 60, 0, 0, 0, 0, 64, 0, 0,
        0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0,
        0, 0, 0, 46, 60, 0, 0, 0, 0, 0, 0, 0, 61, 47, 48,
        46, 47, 47, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64,
        62, 0, 0, 0, 0, 0, 0, 0, 0, 0, 124, 175, 125, 0, 64,
        62, 0, 0, 0, 0, 0, 0, 0, 0, 0, 160, 0, 158, 0, 64,
        62, 0, 0, 0, 0, 0, 0, 0, 0, 0, 140, 143, 141, 0, 64,
        78, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64,
        0, 78, 79, 79, 76, 0, 0, 0, 0, 127, 0, 0, 0, 0, 64,
        0, 0, 0, 0, 78, 76, 0, 0, 0, 77, 79, 79, 79, 79, 80,
        0, 0, 0, 0, 0, 62, 0, 0, 0, 64, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 62, 0, 0, 0, 64, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 4,
      name = "trees",
      x = 0,
      y = 0,
      width = 15,
      height = 30,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        134, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        150, 151, 152, 153, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        166, 167, 168, 169, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 218,
        182, 183, 184, 185, 0, 218, 219, 0, 0, 0, 0, 0, 0, 0, 234,
        0, 199, 200, 201, 0, 234, 235, 0, 0, 0, 0, 0, 0, 0, 250,
        0, 0, 0, 0, 0, 250, 251, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 218, 219, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 235, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 250, 251, 0, 0,
        219, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 151,
        251, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 133, 134, 167,
        151, 152, 153, 0, 0, 0, 0, 0, 0, 0, 197, 198, 149, 150, 183,
        167, 168, 169, 151, 152, 153, 0, 0, 0, 0, 213, 214, 165, 166, 199,
        183, 184, 185, 167, 168, 169, 0, 0, 0, 0, 229, 230, 181, 182, 0,
        199, 200, 201, 183, 184, 185, 0, 0, 0, 0, 245, 246, 0, 0, 0,
        0, 0, 0, 199, 200, 201, 0, 0, 0, 133, 134, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 149, 150, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 165, 166, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 3,
      name = "rocks",
      x = 0,
      y = 0,
      width = 15,
      height = 30,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        24, 25, 26, 23, 40, 41, 42, 39, 40, 39, 40, 25, 26, 23, 24,
        40, 41, 42, 39, 56, 57, 58, 223, 224, 55, 56, 41, 42, 39, 40,
        194, 195, 196, 71, 72, 73, 74, 239, 240, 71, 72, 73, 74, 71, 55,
        210, 211, 212, 87, 88, 89, 90, 255, 256, 87, 88, 89, 90, 209, 193,
        226, 227, 228, 103, 104, 105, 106, 0, 0, 103, 104, 105, 106, 225, 66,
        242, 243, 244, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 82,
        22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 117, 97, 98,
        38, 0, 117, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 154,
        54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17,
        70, 0, 0, 0, 0, 0, 0, 0, 0, 117, 0, 0, 0, 0, 33,
        86, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49,
        102, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 65,
        0, 0, 0, 0, 0, 117, 0, 0, 0, 0, 0, 0, 0, 0, 81,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 97,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 117, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 8, 9,
        26, 2, 3, 4, 5, 6, 0, 0, 0, 1, 2, 3, 23, 24, 25,
        42, 18, 19, 20, 21, 22, 0, 0, 119, 17, 18, 19, 20, 21, 40,
        58, 34, 35, 36, 37, 38, 0, 0, 135, 33, 34, 35, 36, 37, 39,
        69, 55, 51, 52, 53, 54, 0, 0, 0, 49, 50, 51, 52, 53, 55,
        85, 66, 67, 68, 69, 70, 0, 0, 0, 65, 66, 67, 68, 69, 71,
        85, 89, 83, 84, 85, 86, 0, 0, 0, 81, 82, 83, 84, 85, 87
      }
    },
    {
      type = "tilelayer",
      id = 5,
      name = "details",
      x = 0,
      y = 0,
      width = 15,
      height = 30,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 138, 657, 0, 0, 0, 0, 0, 117, 141, 0, 0,
        124, 125, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 657, 0,
        140, 141, 0, 0, 0, 989, 0, 0, 0, 0, 989, 0, 0, 172, 0,
        0, 0, 0, 0, 0, 1021, 0, 0, 0, 0, 1021, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 657, 120, 0, 0, 0, 0, 656, 657, 0, 0, 81, 0,
        0, 0, 0, 0, 136, 0, 0, 0, 0, 657, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        134, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        150, 197, 198, 215, 216, 217, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        166, 213, 214, 231, 232, 233, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        182, 229, 230, 247, 248, 249, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 245, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 124, 125, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 140, 141, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        124, 125, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 124, 125, 0,
        140, 141, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 140, 141, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    }
  }
}
