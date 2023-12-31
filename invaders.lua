local invaders = {}
invaders.rows = 5
invaders.columns = 9
invaders.top_left_position_x = 50
invaders.top_left_position_y = 50
invaders.invader_width = 40
invaders.invader_height = 40
invaders.horizontal_distance = 20
invaders.vertical_distance = 30
invaders.current_speed_x = 50
invaders.current_level_invaders = {}
local initial_speed_x = 50
local initial_direction = 'right'
function invaders.new_invader( position_x, position_y )
    return { position_x = position_x,
                 position_y = position_y,
                 width = invaders.invader_width,
                 height = invaders.invader_height }
end
function invaders.new_row( row_index )
    local row = {}
    for col_index=1, invaders.columns do
    local new_invader_position_x = invaders.top_left_position_x + (col_index - 1) * (invaders.invader_width + invaders.horizontal_distance)
        local new_invader_position_y = invaders.top_left_position_y + (row_index - 1) * (invaders.invader_height + invaders.vertical_distance)
        local new_invader = invaders.new_invader( new_invader_position_x, new_invader_position_y )
        table.insert( row, new_invader )
    end
    return row
end
function invaders.construct_level()
    invaders.current_speed_x = initial_speed_x
    for row_index=1, invaders.rows do
        local invaders_row = invaders.new_row( row_index )
        table.insert( invaders.current_level_invaders, invaders_row )
    end
end
function invaders.draw_invader( single_invader )
    love.graphics.rectangle('line',
                       single_invader.position_x,
                       single_invader.position_y,
                       single_invader.width,
                       single_invader.height )
end
function invaders.draw()
    for _, invader_row in pairs( invaders.current_level_invaders ) do
        for _, invader in pairs( invader_row ) do
            invaders.draw_invader( invader, is_miniboss )
        end
    end
end
function invaders.update_invader( dt, single_invader )
    single_invader.position_x = single_invader.position_x + invaders.current_speed_x * dt
end
function invaders.update( dt )
    local invaders_rows = 0
    for _, invader_row in pairs( invaders.current_level_invaders ) do
        invaders_rows = invaders_rows + 1
    end
    if invaders_rows == 0 then
        invaders.no_more_invaders = true
    else
        for _, invader_row in pairs( invaders.current_level_invaders ) do
            for _, invader in pairs( invader_row ) do
                invaders.update_invader( dt, invader )
            end
        end
    end
end

invaders.allow_overlap_direction = 'right'
function invaders.descend_by_row_invader( single_invader )
    single_invader.position_y = single_invader.position_y + invaders.vertical_distance / 2
end
function invaders.descend_by_row()
    for _, invader_row in pairs( invaders.current_level_invaders ) do
        for _, invader in pairs( invader_row ) do
            invaders.descend_by_row_invader( invader )
        end
    end
end

invaders.speed_x_increase_on_destroying = 10
function invaders.destroy_invader( row, invader )
    invaders.current_level_invaders[row][invader] = nil
    local invaders_row_count = 0
    for _, invader in pairs( invaders.current_level_invaders[row] ) do
        invaders_row_count = invaders_row_count + 1
    end
    if invaders_row_count == 0 then
        invaders.current_level_invaders[row] = nil
    end
    if invaders.allow_overlap_direction == 'right' then
        invaders.current_speed_x = invaders.current_speed_x + invaders.speed_x_increase_on_destroying
    else
        invaders.current_speed_x = invaders.current_speed_x - invaders.speed_x_increase_on_destroying
    end
 end
 
return invaders