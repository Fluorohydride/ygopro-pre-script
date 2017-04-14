--変則ギア
--Trasmission Gear
--Scripted by Eerie Code
--Might require a core update for better functionality
function c101001080.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14469229,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetTarget(c101001080.target)
	e1:SetOperation(c101001080.activate)
	c:RegisterEffect(e1)
end
function c101001080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if chk==0 then return d and a:GetControler()~=d:GetControler()
		and a:IsAbleToRemove() and d:IsAbleToRemove() end
end
function c101001080.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
	if a:IsControler(1-tp) then a,d=d,a end
	local rock=Duel.CreateToken(tp,101001180)
	local paper=Duel.CreateToken(tp,101001181)
	local xors=Duel.CreateToken(tp,101001182)
	local ch=Group.FromCards(rock,paper,xors)
	local res=-1
	while res=-1 do
		local r0=ch:Select(tp,1,1,nil)
		local r1=ch:Select(1-tp,1,1,nil)
		Duel.ConfirmCards(tp,r1)
		Duel.ConfirmCards(1-tp,r0)
		if r0==rock then
			if r1==rock then res=-1 elseif r1==paper then res=1-tp else res=tp end
		elseif r0==paper then
			if r1==paper then res=-1 elseif r1==xors then res=1-tp else res=tp end
		else
			if r1==xors then res=-1 elseif r1==rock then res=1-tp else res=tp end
		end
	end
	if res==tp then
		Duel.Remove(a,POS_FACEDOWN,REASON_EFFECT)
	else
		Duel.Remove(d,POS_FACEDOWN,REASON_EFFECT)
	end
end
