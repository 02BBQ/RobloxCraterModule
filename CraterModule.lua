local module = {}

local random = Random.new()
local RayParams = RaycastParams.new();
RayParams.FilterDescendantsInstances = { workspace.Map };
RayParams.FilterType = Enum.RaycastFilterType.Whitelist;
local coroutine_rseume = coroutine.resume;
local coroutine_create = coroutine.create;
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService");
module.Crater = function(things)
	local cframe = things.Cframe or CFrame.new();
	local Size = things.Size or 4;
	local ray = workspace:Raycast((cframe * CFrame.new(0, 3, 0)).Position, Vector3.new(0, -20, 0), RayParams);
	if ray and ray.Position then
		local Ammount = things.Ammount or 6;
		local Distance = things.Distance or 6;
		local Despawn = things.Despawn or 1;
		local Stack = things.Stack or 2
		local Reverse = things.Reverse
		local DespawnSize = Size / 4;
		task.spawn(function()
			local Rocks = script.Rocks:GetChildren();
			local zero = 1 - 1;
			local current = zero;
			while true do
				task.spawn(function()
					for v7 = 1, Stack do
						local function Crater()
							local angle = (360/Ammount)/2

							local CF = CFrame.new(ray.Position, ray.Position + ray.Normal) * CFrame.Angles(-math.pi/2, math.rad(360/Ammount*current + math.random(-angle,angle)), 0) * CFrame.new(0, 0, math.random(-Distance, -Distance / 1.5) * v7);
							local ray = workspace:Raycast((CF * CFrame.new(0, 3, 0)).Position, Vector3.new(0, -20, 0), RayParams);
							if ray and ray.Instance and ray.Instance.Transparency < 1 then
								local Rock = Rocks[math.random(1, #Rocks)]:Clone();
								Debris:AddItem(Rock, 4 + Despawn);
								Rock.Color = ray.Instance.Color;
								Rock.Material = ray.Material;
								Rock.CFrame = CF * CFrame.new(0, -24.5, 0);
								Rock.Size = Vector3.new(math.random(Size, Size + 1)*v7, math.random(Size, Size + 1)*v7/3, math.random(Size, Size + 2) * v7 ) 	;
								Rock.Parent = workspace.Debris;
								TweenService:Create(Rock, TweenInfo.new(math.random() / 10, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0), {
									CFrame = Rock.CFrame * CFrame.new(0, Size <3 and 24.5 or math.random(23, 24), 0) * CFrame.Angles(math.rad( (Reverse and -1 or 1) *math.random(15, 25)), 0,math.rad(math.random(-10,10)))
								}):Play();
								task.delay(Despawn, function()
									TweenService:Create(Rock, TweenInfo.new(Random.new():NextNumber(0.1, 0.5), Enum.EasingStyle.Back, Enum.EasingDirection.In), {
										CFrame = Rock.CFrame * CFrame.new(0, -7 * DespawnSize, 0)
									}):Play();
								end);
							end;
						end
						Crater()
						if Stack > 1 then
							Crater()
						end
					end;
				end);
				if not (current < Ammount) then
					break;
				end;
				current += 1;			
			end;
		end)
	end;
end;


module.Trail = function(parent,size,k,despawntime)
	local function rocknew(khoangcach)
		local p = Instance.new("Part")
		game.Debris:AddItem(p,despawntime + 1)
		p.Anchored = true
		p.CanCollide = true
		p.Size = Vector3.new(0,0,0)
		local origin = typeof(parent) == "CFrame" and parent or parent.CFrame
		p.CFrame = origin * CFrame.new(khoangcach,0,0)
		p.Orientation = Vector3.new(math.random(-180,180),math.random(-180.,180),math.random(-180,180))
		local ray = workspace:Raycast(p.Position, Vector3.new(0,-20,0), RayParams)
		if ray then
			p.Position = ray.Position
			p.Color = ray.Instance.Color
			p.Material = ray.Material
			p.Parent = workspace.Debris
			game.TweenService:Create(p,TweenInfo.new(.25),{Size = Vector3.new(size,size,size)}):Play()
			delay(despawntime,function()
				game.TweenService:Create(p,TweenInfo.new(.5),{Size = Vector3.new(0,0,0)}):Play()
			end)
		else
			game.Debris:AddItem(p,0)
		end
	end
	spawn(function()
		rocknew(k)
		rocknew(-k)
	end)
end

module.TrailSpikey = function(things)
	local origin = things.origin;
	local size = things.size or 6;
	local distance = things.distance or 5;
	local despawntime = things.despawntime or 2
	if not origin then return end
	local Rocks = script.Rocks:GetChildren();
	for i=1,2 do
		local x = i == 1 and distance or -distance
		x *= random:NextNumber(1,1.7)
		local p = Rocks[math.random(1, #Rocks)]:Clone();
		game.Debris:AddItem(p,despawntime + 1)
		p.Size = Vector3.new(0,0,0)
		local origin : CFrame = typeof(origin) == "CFrame" and origin or origin.CFrame
		p.CFrame = origin * CFrame.new(x,0,0)
		local ray = workspace:Raycast(p.Position, Vector3.new(0,-20,0), RayParams)
		if ray then
			p.Position = ray.Position
			local cf = origin*CFrame.new()

			p.CFrame = CFrame.new(p.Position, (origin*CFrame.new(-x,15*size,0)).p) * CFrame.new(0,-1.5,0)
			p.Orientation += Vector3.new(random:NextNumber(-5,5),random:NextNumber(-5,5),random:NextNumber(-5,5))
			p.Color = ray.Instance.Color
			p.Material = ray.Material
			p.Parent = workspace.Debris
			local size2 = Vector3.new(size*random:NextNumber(1,5),size*random:NextNumber(1,5),size*random:NextNumber(1,1.5))
			TweenService:Create(p,TweenInfo.new(.25),{Size = size2}):Play()
			task.delay(despawntime,function()
				TweenService:Create(p,TweenInfo.new(random:NextNumber(.1,.3), Enum.EasingStyle.Back, Enum.EasingDirection.In),{Position = p.Position -Vector3.new(0,random:NextNumber(12,20),0)}):Play()
			end)
		else
			game.Debris:AddItem(p,0)
		end
	end
end

return module
