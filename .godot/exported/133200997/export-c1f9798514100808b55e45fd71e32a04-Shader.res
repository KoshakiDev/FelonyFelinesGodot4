RSRC                     VisualShader            ��������                                            5      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    source    texture    texture_type    script    op_type 	   operator    parameter_name 
   qualifier    default_value_enabled    default_value 	   constant    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/9/node    nodes/fragment/9/position    nodes/fragment/11/node    nodes/fragment/11/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        &   local://VisualShaderNodeTexture_wrem3 �      '   local://VisualShaderNodeVectorOp_ts0rp �      '   local://VisualShaderNodeVectorOp_up27p       /   local://VisualShaderNodeBooleanParameter_4mtg8 K      ,   local://VisualShaderNodeColorConstant_sk3cq �         local://VisualShader_evhne �         VisualShaderNodeTexture                      VisualShaderNodeVectorOp    
                  VisualShaderNodeVectorOp    
               !   VisualShaderNodeBooleanParameter             active          VisualShaderNodeColorConstant             VisualShader          �  shader_type canvas_item;
uniform bool active;



void fragment() {
	vec4 n_out3p0;
// Texture2D:3
	n_out3p0 = texture(TEXTURE, UV);


// BooleanParameter:9
	bool n_out9p0 = active;


// ColorConstant:11
	vec4 n_out11p0 = vec4(1.000000, 1.000000, 1.000000, 1.000000);


// VectorOp:6
	vec3 n_out6p0 = vec3(n_out9p0 ? 1.0 : 0.0) * vec3(n_out11p0.xyz);


// VectorOp:5
	vec3 n_out5p0 = max(vec3(n_out3p0.xyz), n_out6p0);


// Output:0
	COLOR.rgb = n_out5p0;


}
                       
     �D  pB                
     D   �               
     WD  p�               
     D  �B             !   
     �C    "            #   
     �C  �B$                                                    	                                 RSRC