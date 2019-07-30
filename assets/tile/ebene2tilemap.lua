return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.4",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 30,
  height = 60,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 9,
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
      width = 30,
      height = 60,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        11, 11, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 44, 93, 93, 93, 93, 93, 92, 93, 93, 93, 108, 108, 11, 11, 12, 11, 12,
        27, 27, 43, 43, 43, 44, 108, 108, 108, 108, 108, 92, 92, 92, 92, 92, 93, 109, 109, 93, 93, 109, 109, 108, 11, 27, 11, 11, 11, 12,
        43, 43, 43, 44, 108, 92, 93, 93, 93, 93, 93, 93, 93, 93, 93, 92, 92, 93, 109, 109, 109, 108, 108, 11, 11, 43, 27, 27, 27, 11,
        43, 43, 43, 108, 92, 93, 93, 109, 109, 109, 109, 109, 92, 93, 109, 93, 93, 93, 108, 108, 108, 11, 11, 11, 11, 12, 43, 43, 11, 12,
        43, 44, 43, 92, 93, 93, 13, 93, 93, 93, 93, 93, 92, 93, 109, 109, 109, 109, 108, 108, 11, 11, 11, 27, 11, 11, 12, 12, 12, 12,
        44, 12, 43, 92, 93, 92, 93, 93, 92, 93, 93, 109, 93, 93, 108, 108, 92, 92, 92, 92, 93, 27, 27, 43, 27, 11, 12, 28, 28, 28,
        44, 28, 43, 92, 93, 92, 93, 92, 93, 93, 109, 109, 109, 92, 93, 93, 93, 93, 93, 93, 93, 43, 43, 43, 11, 12, 12, 11, 12, 12,
        44, 44, 43, 92, 93, 92, 92, 93, 93, 109, 109, 108, 92, 92, 93, 109, 109, 109, 92, 92, 92, 93, 44, 11, 12, 12, 28, 27, 28, 28,
        43, 44, 43, 92, 92, 92, 93, 93, 109, 92, 93, 92, 93, 92, 92, 92, 92, 92, 108, 108, 92, 93, 12, 12, 12, 28, 44, 43, 44, 44,
        43, 44, 43, 93, 92, 92, 93, 109, 109, 108, 109, 108, 109, 108, 108, 92, 92, 92, 93, 109, 108, 109, 28, 12, 28, 44, 12, 12, 12, 44,
        43, 44, 43, 92, 93, 92, 93, 108, 109, 108, 27, 11, 11, 11, 12, 108, 108, 108, 109, 28, 12, 44, 44, 12, 44, 12, 12, 28, 11, 43,
        43, 44, 43, 92, 93, 92, 92, 93, 109, 93, 43, 27, 27, 11, 11, 12, 28, 28, 44, 12, 12, 28, 28, 12, 28, 28, 44, 44, 27, 43,
        43, 43, 43, 92, 92, 108, 108, 109, 108, 109, 93, 43, 43, 27, 11, 11, 11, 11, 11, 12, 28, 44, 44, 44, 44, 44, 11, 11, 43, 43,
        43, 43, 92, 108, 92, 92, 92, 93, 108, 109, 109, 108, 108, 43, 27, 27, 27, 11, 12, 12, 11, 12, 27, 27, 43, 11, 11, 27, 43, 44,
        43, 93, 93, 93, 108, 108, 92, 92, 92, 108, 109, 93, 108, 108, 43, 43, 43, 27, 12, 27, 11, 11, 12, 11, 11, 12, 27, 43, 43, 44,
        12, 43, 109, 109, 109, 109, 108, 108, 108, 108, 109, 109, 13, 108, 108, 108, 108, 43, 43, 43, 27, 11, 11, 27, 27, 43, 43, 43, 44, 12,
        11, 12, 108, 92, 92, 108, 109, 109, 93, 108, 108, 109, 92, 92, 92, 93, 108, 108, 108, 108, 43, 27, 11, 43, 43, 44, 44, 44, 12, 28,
        11, 12, 108, 108, 92, 92, 93, 108, 109, 109, 93, 93, 93, 93, 93, 109, 92, 93, 93, 93, 93, 43, 27, 27, 11, 11, 12, 43, 12, 12,
        11, 11, 12, 108, 108, 92, 92, 92, 92, 108, 109, 109, 109, 109, 109, 93, 93, 93, 109, 93, 109, 93, 43, 43, 27, 11, 11, 12, 43, 44,
        11, 11, 11, 11, 12, 108, 108, 108, 92, 92, 92, 108, 109, 109, 109, 109, 109, 109, 109, 109, 93, 109, 93, 108, 43, 27, 11, 12, 43, 12,
        27, 27, 27, 11, 11, 11, 11, 12, 108, 108, 108, 108, 92, 92, 92, 92, 92, 108, 108, 109, 109, 93, 109, 93, 93, 43, 27, 28, 43, 12,
        43, 43, 43, 11, 12, 12, 12, 11, 11, 12, 108, 108, 108, 108, 108, 108, 92, 92, 108, 108, 109, 109, 108, 13, 109, 108, 11, 11, 43, 12,
        44, 11, 12, 12, 12, 28, 28, 12, 11, 11, 11, 11, 11, 11, 11, 12, 108, 108, 92, 108, 108, 109, 93, 108, 109, 108, 27, 11, 43, 12,
        11, 12, 12, 28, 28, 44, 44, 28, 12, 27, 11, 27, 27, 27, 11, 11, 11, 12, 108, 92, 108, 109, 109, 108, 109, 108, 43, 11, 43, 12,
        12, 12, 28, 44, 44, 43, 44, 44, 28, 43, 11, 12, 12, 12, 27, 27, 11, 12, 108, 92, 93, 108, 109, 108, 109, 108, 11, 12, 43, 12,
        11, 12, 44, 44, 28, 12, 43, 44, 44, 12, 12, 12, 28, 28, 12, 11, 12, 12, 108, 92, 93, 92, 108, 109, 109, 108, 11, 12, 43, 12,
        11, 11, 12, 43, 44, 28, 28, 43, 44, 28, 12, 28, 44, 12, 12, 11, 12, 28, 108, 92, 92, 92, 108, 109, 108, 11, 12, 11, 43, 12,
        27, 11, 11, 12, 44, 44, 44, 12, 12, 44, 28, 44, 43, 44, 44, 12, 12, 44, 108, 92, 108, 108, 108, 109, 108, 11, 12, 27, 43, 12,
        43, 27, 11, 11, 12, 44, 43, 44, 43, 44, 44, 11, 43, 43, 44, 12, 28, 108, 108, 108, 108, 108, 109, 108, 11, 12, 11, 43, 43, 12,
        28, 43, 27, 11, 12, 12, 12, 43, 44, 44, 12, 27, 43, 44, 12, 28, 44, 108, 92, 93, 109, 108, 108, 108, 11, 12, 27, 43, 44, 44,
        44, 11, 43, 11, 11, 12, 11, 43, 43, 44, 11, 43, 43, 44, 28, 44, 108, 92, 93, 93, 108, 108, 11, 11, 11, 12, 43, 43, 44, 44,
        12, 12, 28, 27, 11, 12, 27, 43, 44, 44, 11, 43, 44, 44, 44, 108, 108, 92, 93, 109, 108, 11, 27, 27, 11, 12, 11, 27, 43, 12,
        28, 28, 44, 43, 11, 12, 43, 44, 43, 43, 27, 43, 44, 108, 108, 108, 92, 93, 93, 108, 108, 27, 43, 11, 11, 12, 27, 43, 43, 44,
        44, 11, 11, 27, 27, 11, 12, 27, 11, 12, 12, 43, 44, 108, 108, 92, 93, 109, 109, 108, 11, 43, 43, 11, 12, 12, 43, 43, 44, 44,
        11, 27, 27, 43, 11, 12, 12, 43, 27, 28, 28, 12, 108, 108, 92, 93, 93, 108, 108, 108, 27, 43, 44, 11, 11, 11, 11, 12, 43, 44,
        27, 43, 43, 44, 11, 11, 11, 11, 43, 44, 44, 28, 108, 92, 93, 93, 109, 11, 12, 11, 12, 43, 43, 27, 27, 27, 11, 11, 27, 43,
        43, 44, 27, 43, 11, 27, 27, 27, 27, 43, 44, 44, 108, 92, 93, 109, 108, 27, 28, 27, 28, 44, 44, 43, 43, 43, 27, 27, 43, 43,
        11, 27, 43, 43, 27, 43, 43, 43, 43, 43, 43, 44, 92, 93, 93, 93, 108, 43, 44, 43, 44, 108, 108, 108, 108, 108, 43, 43, 43, 12,
        27, 43, 43, 44, 43, 43, 44, 108, 108, 108, 108, 92, 92, 93, 109, 109, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 108, 12, 12,
        43, 43, 44, 93, 93, 93, 93, 93, 93, 93, 92, 92, 93, 35, 108, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 93, 12, 28,
        43, 44, 93, 109, 13, 93, 93, 93, 93, 93, 93, 35, 92, 92, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 13, 93, 12, 44,
        13, 92, 92, 92, 92, 92, 92, 92, 92, 35, 35, 108, 108, 108, 92, 92, 92, 92, 93, 109, 109, 109, 109, 109, 109, 109, 109, 109, 12, 44,
        13, 108, 108, 92, 108, 108, 108, 108, 35, 35, 92, 92, 92, 92, 108, 108, 108, 108, 92, 92, 92, 92, 93, 92, 108, 108, 108, 109, 63, 44,
        12, 108, 108, 108, 92, 92, 92, 92, 108, 35, 35, 108, 108, 108, 92, 93, 108, 108, 35, 108, 108, 108, 92, 92, 92, 92, 92, 92, 12, 44,
        11, 11, 12, 108, 108, 108, 108, 108, 92, 92, 92, 92, 92, 92, 93, 93, 92, 92, 13, 92, 92, 92, 108, 108, 108, 108, 108, 108, 28, 44,
        27, 11, 11, 11, 12, 108, 108, 108, 108, 11, 11, 12, 92, 93, 92, 93, 93, 108, 108, 108, 108, 108, 108, 108, 109, 108, 108, 108, 44, 44,
        43, 27, 27, 11, 11, 11, 11, 11, 11, 27, 11, 12, 92, 93, 108, 109, 109, 93, 109, 11, 12, 13, 13, 13, 11, 12, 13, 13, 13, 44,
        11, 12, 12, 27, 27, 27, 27, 27, 27, 11, 12, 12, 92, 92, 93, 108, 109, 109, 108, 11, 12, 13, 29, 29, 13, 13, 13, 29, 29, 29,
        11, 12, 28, 12, 12, 43, 43, 43, 11, 12, 12, 12, 92, 93, 93, 92, 108, 109, 108, 11, 12, 13, 45, 45, 29, 29, 11, 11, 11, 12,
        12, 12, 12, 12, 28, 12, 12, 12, 12, 12, 12, 28, 92, 92, 93, 108, 109, 108, 108, 11, 12, 13, 44, 11, 11, 11, 27, 27, 11, 12,
        12, 28, 12, 44, 12, 28, 12, 12, 28, 44, 44, 12, 92, 93, 92, 108, 109, 108, 11, 12, 13, 13, 11, 27, 27, 27, 43, 11, 12, 13,
        11, 11, 12, 12, 44, 12, 12, 44, 11, 12, 12, 92, 93, 93, 108, 108, 109, 108, 11, 11, 12, 11, 27, 43, 43, 11, 12, 13, 13, 13,
        11, 11, 11, 12, 11, 12, 12, 12, 12, 12, 28, 92, 93, 109, 108, 109, 108, 44, 27, 11, 12, 27, 43, 43, 44, 11, 12, 13, 29, 29,
        11, 27, 11, 11, 27, 28, 12, 28, 28, 12, 12, 92, 92, 92, 108, 109, 108, 44, 43, 11, 12, 43, 43, 44, 45, 27, 11, 12, 13, 45,
        27, 43, 27, 27, 43, 44, 44, 12, 44, 12, 28, 108, 108, 108, 108, 109, 108, 108, 11, 12, 13, 43, 44, 45, 13, 43, 11, 11, 12, 13,
        11, 12, 43, 43, 27, 43, 43, 43, 44, 12, 44, 108, 108, 92, 93, 93, 93, 108, 11, 12, 13, 43, 44, 45, 29, 13, 27, 11, 11, 12,
        11, 12, 12, 12, 11, 11, 11, 11, 11, 11, 12, 108, 108, 92, 93, 109, 109, 108, 11, 12, 13, 43, 44, 45, 45, 29, 43, 27, 11, 12,
        12, 11, 11, 11, 27, 27, 27, 11, 11, 11, 11, 12, 108, 92, 93, 93, 108, 11, 11, 11, 11, 11, 43, 44, 45, 45, 45, 43, 11, 12,
        11, 27, 27, 27, 43, 11, 11, 27, 27, 11, 27, 28, 108, 92, 93, 109, 108, 27, 27, 27, 27, 27, 27, 27, 27, 27, 43, 43, 11, 12,
        27, 43, 43, 43, 43, 27, 27, 43, 43, 27, 43, 44, 108, 108, 109, 108, 108, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 44, 27, 28
      }
    },
    {
      type = "tilelayer",
      id = 3,
      name = "road_edges",
      x = 0,
      y = 0,
      width = 30,
      height = 60,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 46, 47, 47, 47, 47, 47, 47, 47, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0,
        0, 0, 0, 46, 47, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 77, 80, 0, 0, 0, 0,
        0, 0, 46, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 77, 80, 0, 0, 0, 0, 0,
        0, 0, 62, 0, 0, 124, 175, 125, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 77, 79, 80, 0, 0, 0, 0, 0, 0,
        0, 0, 62, 0, 0, 160, 0, 158, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 77, 80, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 62, 0, 0, 140, 143, 141, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 172, 172, 172, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 172, 172, 172, 172, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 172, 172, 172, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 0, 0, 172, 172, 172, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 172, 172, 172, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 77, 79, 79, 79, 76, 0, 0, 0, 0, 77, 79, 79, 80, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 61, 48, 0, 0, 78, 79, 79, 79, 79, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 46, 60, 0, 0, 0, 0, 0, 0, 0, 0, 61, 47, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        46, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 61, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        62, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 124, 175, 125, 61, 47, 47, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        78, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 160, 0, 158, 0, 0, 0, 61, 47, 47, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 62, 0, 0, 0, 0, 0, 0, 0, 0, 0, 140, 143, 141, 0, 0, 0, 0, 0, 0, 61, 48, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 62, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 61, 48, 0, 0, 0, 0, 0, 0, 0,
        0, 78, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 61, 47, 48, 0, 0, 0, 0, 0,
        0, 0, 78, 79, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 61, 48, 0, 0, 0, 0,
        0, 0, 0, 0, 78, 79, 79, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 124, 175, 125, 61, 48, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 78, 79, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 160, 0, 158, 0, 64, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 78, 79, 79, 79, 79, 79, 76, 0, 0, 0, 0, 0, 0, 140, 143, 141, 0, 64, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 78, 79, 76, 0, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 77, 80, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 60, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 77, 80, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 60, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 60, 0, 0, 0, 0, 0, 0, 77, 79, 80, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 47, 60, 0, 0, 0, 0, 0, 0, 77, 80, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 60, 0, 0, 0, 0, 0, 0, 0, 77, 80, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 77, 79, 79, 80, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 64, 0, 0, 46, 47, 47, 47, 47, 47, 48, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 46, 47, 47, 47, 47, 60, 0, 0, 0, 0, 0, 61, 47, 47, 60, 0, 0, 0, 0, 0, 61, 47, 48, 0,
        0, 0, 46, 47, 47, 47, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64, 123,
        0, 46, 60, 124, 175, 125, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 124, 175, 125, 64, 123,
        46, 60, 0, 160, 0, 158, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 160, 0, 158, 64, 0,
        62, 0, 0, 140, 143, 141, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 140, 143, 141, 61, 48,
        62, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 123, 64,
        62, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 124, 175, 125, 0, 0, 0, 0, 0, 0, 0, 0, 77, 80,
        78, 79, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 160, 0, 158, 0, 0, 0, 0, 0, 0, 0, 0, 64, 0,
        0, 0, 78, 79, 76, 0, 0, 0, 0, 77, 79, 76, 0, 0, 0, 0, 0, 140, 143, 141, 0, 0, 0, 0, 0, 0, 0, 0, 64, 123,
        0, 0, 0, 0, 78, 79, 79, 79, 79, 80, 0, 62, 0, 0, 0, 0, 0, 0, 0, 77, 79, 79, 79, 79, 79, 79, 79, 79, 80, 123,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 124, 125, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 140, 141, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 60, 0, 0, 0, 0, 0, 0, 77, 80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 0, 77, 80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 0, 61, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 78, 76, 0, 0, 0, 0, 0, 77, 80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 7,
      name = "trees",
      x = 0,
      y = 0,
      width = 30,
      height = 60,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 139, 0, 139, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 218, 219, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 235, 0, 0, 0, 0,
        0, 0, 133, 134, 0, 0, 197, 198, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 250, 251, 0, 0, 0, 0,
        152, 153, 149, 150, 197, 198, 213, 214, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        168, 169, 165, 166, 213, 214, 229, 230, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        184, 185, 181, 182, 229, 230, 245, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        200, 201, 0, 0, 245, 246, 0, 154, 155, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 170, 171, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 186, 187, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 186, 187, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 218,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 250,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 215, 216,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 231, 232,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 247, 248,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 218, 219, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 234, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 250, 251, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 218, 219, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 235, 0, 0, 0,
        198, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 250, 251, 0, 0, 0,
        214, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 151, 152,
        230, 151, 152, 153, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 151, 152, 153, 0, 0, 0, 0, 167, 168,
        246, 167, 168, 169, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 167, 168, 169, 151, 152, 153, 0, 183, 184,
        0, 183, 184, 185, 151, 152, 153, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 183, 184, 185, 167, 168, 169, 0, 199, 200,
        0, 199, 200, 201, 167, 168, 169, 151, 152, 153, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 199, 200, 201, 183, 184, 185, 0, 0, 0,
        0, 0, 0, 0, 183, 184, 185, 167, 168, 169, 0, 0, 0, 0, 0, 0, 0, 0, 0, 151, 152, 153, 0, 0, 199, 200, 201, 0, 0, 0,
        0, 0, 0, 0, 199, 200, 201, 183, 184, 185, 0, 0, 0, 0, 0, 0, 0, 0, 0, 167, 168, 169, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 199, 200, 201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 183, 184, 185, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 199, 200, 201, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 151, 152, 153, 0, 0, 0, 0, 0, 133, 134, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 167, 168, 169, 0, 0, 0, 0, 0, 149, 150, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 183, 184, 185, 0, 0, 0, 0, 0, 165, 166, 0, 0, 0, 0, 0, 0, 215, 216, 217, 216,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 199, 200, 201, 0, 0, 0, 0, 0, 181, 182, 0, 0, 0, 0, 0, 0, 231, 232, 233, 232,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 247, 248, 249, 248
      }
    },
    {
      type = "tilelayer",
      id = 4,
      name = "rocks",
      x = 0,
      y = 0,
      width = 30,
      height = 60,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {
        ["isSolid"] = true
      },
      encoding = "lua",
      data = {
        164, 180, 82, 83, 84, 85, 82, 83, 84, 85, 82, 83, 84, 82, 83, 84, 82, 83, 84, 82, 83, 86, 81, 82, 82, 83, 84, 85, 177, 161,
        180, 35, 52, 37, 129, 130, 131, 132, 129, 130, 117, 58, 145, 146, 147, 148, 145, 146, 147, 148, 129, 130, 131, 132, 113, 35, 35, 52, 35, 177,
        50, 51, 52, 39, 114, 115, 116, 69, 66, 67, 68, 69, 66, 210, 211, 223, 224, 210, 210, 211, 72, 73, 72, 73, 129, 130, 131, 132, 36, 37,
        66, 55, 114, 115, 116, 113, 114, 115, 116, 83, 84, 85, 82, 226, 227, 239, 240, 226, 226, 227, 88, 113, 114, 115, 58, 39, 114, 115, 116, 53,
        82, 71, 130, 131, 132, 129, 130, 131, 132, 99, 100, 101, 98, 242, 243, 255, 256, 242, 242, 243, 104, 129, 117, 131, 132, 129, 39, 114, 115, 116,
        114, 115, 117, 147, 148, 145, 146, 147, 148, 0, 0, 155, 0, 0, 0, 0, 0, 0, 0, 0, 0, 145, 146, 147, 148, 145, 129, 130, 131, 132,
        130, 131, 132, 163, 164, 161, 162, 163, 164, 0, 170, 155, 170, 139, 0, 0, 0, 0, 0, 117, 0, 71, 72, 73, 74, 71, 145, 146, 147, 148,
        146, 19, 114, 115, 180, 177, 178, 179, 180, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 87, 88, 89, 90, 87, 71, 55, 114, 115,
        66, 129, 130, 131, 70, 0, 0, 0, 0, 0, 0, 0, 0, 117, 0, 0, 0, 0, 657, 656, 0, 103, 104, 105, 106, 103, 87, 71, 55, 117,
        82, 67, 68, 69, 70, 0, 117, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 657, 0, 0, 0, 0, 117, 0, 103, 87, 71, 72,
        98, 83, 84, 85, 86, 0, 0, 0, 0, 656, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 103, 87, 88,
        0, 99, 100, 101, 102, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 138, 103, 104,
        0, 0, 0, 0, 0, 0, 0, 657, 0, 0, 0, 0, 0, 0, 0, 117, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 117, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 117, 0, 0, 0, 0, 0, 33,
        0, 0, 0, 0, 117, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 65,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 65,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81,
        0, 0, 0, 0, 0, 0, 0, 151, 152, 153, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 97,
        0, 151, 152, 153, 0, 197, 198, 167, 168, 169, 0, 117, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 167, 168, 169, 0, 213, 214, 183, 184, 185, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        22, 183, 184, 185, 0, 229, 230, 199, 200, 201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        38, 199, 200, 201, 0, 245, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        70, 0, 0, 0, 215, 216, 217, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        86, 0, 0, 0, 231, 232, 233, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        22, 0, 0, 0, 247, 248, 249, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        38, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        70, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        86, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 117, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 155, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 215, 216, 217, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 231, 232, 233, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        7, 8, 9, 10, 0, 0, 247, 248, 249, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 8, 9, 10, 7,
        23, 24, 25, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 23, 24, 25, 26, 23,
        39, 40, 41, 42, 26, 8, 9, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 8, 9, 10, 39, 40, 41, 42, 39,
        40, 41, 57, 58, 21, 24, 25, 26, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 120, 0, 0, 23, 24, 25, 26, 55, 56, 57, 40, 41,
        40, 40, 40, 40, 41, 40, 41, 37, 38, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 17, 23, 39, 40, 40, 40, 40, 40, 40, 40, 41,
        56, 56, 56, 40, 40, 40, 40, 53, 38, 9, 10, 0, 0, 0, 0, 0, 0, 0, 7, 33, 40, 40, 40, 56, 56, 40, 41, 41, 41, 41,
        40, 41, 41, 41, 41, 56, 40, 40, 21, 25, 26, 22, 0, 0, 0, 0, 0, 0, 1, 49, 56, 56, 56, 40, 41, 41, 41, 40, 40, 40,
        56, 40, 41, 57, 57, 41, 41, 40, 40, 41, 42, 38, 0, 0, 0, 0, 0, 0, 17, 18, 56, 40, 41, 41, 41, 57, 40, 56, 56, 40,
        40, 41, 41, 40, 41, 41, 41, 41, 40, 41, 37, 54, 0, 0, 0, 0, 0, 0, 33, 34, 40, 41, 41, 57, 40, 40, 40, 41, 41, 41,
        40, 41, 57, 40, 41, 57, 40, 41, 41, 41, 37, 54, 0, 0, 0, 0, 0, 0, 49, 50, 40, 41, 41, 40, 56, 40, 41, 41, 57, 57,
        53, 55, 40, 40, 40, 40, 56, 57, 57, 41, 37, 70, 0, 0, 0, 0, 0, 0, 65, 66, 40, 40, 40, 56, 56, 40, 40, 40, 40, 40,
        69, 71, 56, 56, 56, 56, 56, 57, 57, 57, 53, 70, 0, 0, 0, 0, 0, 0, 81, 82, 56, 56, 56, 56, 57, 56, 56, 56, 56, 56
      }
    },
    {
      type = "tilelayer",
      id = 8,
      name = "snow",
      x = 0,
      y = 0,
      width = 30,
      height = 60,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 124, 125, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 989, 0, 0, 0, 0, 989, 0, 0, 0, 0, 0, 140, 141, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1021, 0, 0, 0, 0, 1021, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        125, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 124, 125, 0, 0,
        141, 0, 0, 0, 0, 0, 0, 0, 0, 0, 139, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 140, 141, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 197, 198, 0, 0, 0, 0, 218, 219, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 213, 214, 0, 0, 0, 0, 234, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 229, 230, 0, 0, 0, 0, 250, 251, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 218, 219, 0,
        0, 245, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 235, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 250, 251, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 218, 219, 133, 134,
        0, 0, 151, 152, 153, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 235, 149, 150,
        133, 134, 167, 168, 169, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 250, 251, 165, 166,
        149, 150, 183, 184, 185, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 151, 152, 153, 181, 182,
        165, 166, 199, 200, 201, 218, 219, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 167, 168, 169, 151, 152,
        181, 182, 213, 214, 0, 234, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 183, 184, 185, 167, 168,
        0, 0, 229, 230, 0, 250, 251, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 199, 200, 201, 183, 184
      }
    }
  }
}
