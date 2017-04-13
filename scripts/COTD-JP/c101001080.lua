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
	local res=-1
	--Let's go with 0=ROCK, 1=PAPER, 2=SCISSORS
	while res=-1 do
		r0=Duel.SelectOption(tp,aux.Stringid(101001080,0),aux.Stringid(101001080,1),aux.Stringid(101001080,2))
		r1=Duel.SelectOption(1-tp,aux.Stringid(101001080,0),aux.Stringid(101001080,1),aux.Stringid(101001080,2))
		if r0==0 then
			if r1==0 then res=-1 elseif r1==1 then res=1-tp else res=tp end
		elseif r0==1 then
			if r1==1 then res=-1 elseif r1==2 then res=1-tp else res=tp end
		else
			if r1==2 then res=-1 elseif r1==0 then res=1-tp else res=tp end
		end
	end
	if res==tp then
		Duel.Remove(a,POS_FACEDOWN,REASON_EFFECT)
	else
		Duel.Remove(d,POS_FACEDOWN,REASON_EFFECT)
	end
end
