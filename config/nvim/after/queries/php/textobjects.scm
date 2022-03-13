(class_declaration
  body: (declaration_list) @custom_structure.inner) @custom_structure.outer

(trait_declaration
  body: (declaration_list) @custom_structure.inner) @custom_structure.outer

(interface_declaration
  body: (declaration_list) @custom_structure.inner) @custom_structure.outer

(function_definition 
 body: (compound_statement) @custom_structure.inner) @custom_structure.outer

(method_declaration
  body: (compound_statement) @custom_structure.inner) @custom_structure.outer
