--ドロー・ディスチャージ
--
--Script by mercury233
function c101009067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCode(EVENT_DRAW)
	e1:SetCountLimit(1,101009067+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101009067.condition)
	e1:SetTarget(c101009067.target)
	e1:SetOperation(c101009067.activate)
	c:RegisterEffect(e1)
end
function c101009067.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and r&REASON_EFFECT~=0 and rp==1-tp
end
function c101009067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,EFFECT_IRON_WALL) end
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,LOCATION_HAND)
end
function c101009067.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.ConfirmCards(tp,g)
		local sg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
		if #sg>0 then
			local atk=0
			local tc=sg:GetFirst()
			while tc do
				local tatk=tc:GetAttack()
				if tatk<0 then tatk=0 end
				atk=atk+tatk
				tc=sg:GetNext()
			end
			Duel.Damage(1-tp,atk,REASON_EFFECT)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
		Duel.ShuffleHand(1-tp)
	end
end
