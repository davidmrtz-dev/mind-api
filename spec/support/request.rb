def parsed_body
  body = JSON.parse(response.body)

  if body.instance_of?(Hash)
    body.with_indefferente_access
  elsif body.instance_of?(Array)
    body
  end
end