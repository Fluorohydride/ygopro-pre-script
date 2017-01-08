--ダイス・ポット
function c3549275.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetTarget(c3549275.target)
	e1:SetOperation(c3549275.operation)
	c:RegisterEffect(e1)
end
function c3549275.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,PLAYER_ALL,1)
end
function c3549275.operation(e,tp,eg,ep,ev,re,r,rp)
	local d1=0
	local d2=0
	local first=true
	while d1==d2 do
		d1,d2=Duel.TossDice(tp,1,1)
		if not first then
			Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+100213060+100,re,r,rp,PLAYER_ALL,1)
		end
		first=false
	end
	if d1<d2 then
		if d2==6 then Duel.Damage(tp,6000,REASON_EFFECT) else Duel.Damage(tp,d2*500,REASON_EFFECT) end
	else
		if d1==6 then Duel.Damage(1-tp,6000,REASON_EFFECT) else Duel.Damage(1-tp,d1*500,REASON_EFFECT) end
	end
end
