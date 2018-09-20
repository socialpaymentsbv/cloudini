defprotocol Cloudini.ClientAPI do
  def version(client)
  def upload_image(client, path)
  def upload_image(client, path, opts)
  def upload_video(client, path)
  def upload_video(client, path, opts)
  def delete_image(client, public_id)
  def delete_image(client, public_id, opts)
end
