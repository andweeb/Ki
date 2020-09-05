----------------------------------------------------------------------------------------------------
-- GMail website config
--
local Ki = spoon.Ki
local Website = Ki.Website
local path = "/mail/u/0"

return Website {
    name = "GMail",
    url = "https://mail.google.com",
    links = {
        -- Mail
        { name = "Inbox", link = path.."/#inbox" },
        { name = "Starred", link = path.."/#starred" },
        { name = "Sent", link = path.."/#sent" },
        { name = "Drafts", link = path.."/#drafts" },
        -- More
        { name = "Important", link = path.."/#imp" },
        { name = "Chats", link = path.."/#chats" },
        { name = "Scheduled", link = path.."/#scheduled" },
        { name = "All Mail", link = path.."/#all" },
        { name = "Spam", link = path.."/#spam" },
        { name = "Trash", link = path.."/#trash" },
        -- Categories
        { name = "Social", link = path.."/#category/social" },
        { name = "Updates", link = path.."/#category/updates" },
        { name = "Forums", link = path.."/#category/forums" },
        { name = "Promotions", link = path.."/#category/promotions" },
    },
}
