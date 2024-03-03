module ApplicationHelper
  def cn(*args)
    args.compact.join(" ")
  end
end
