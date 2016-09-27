--十二獣サラブレード
--Juunishishi Thoroughblade
--Script by mercury233
--The "get effect" effect is temporary
function c100911017.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100911017,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c100911017.drtg)
	e1:SetOperation(c100911017.drop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--get effect
	if not c100911017.global_check then
		c100911017.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c100911017.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c100911017.filter(c)
	return c:IsSetCard(0x1f2) and c:IsDiscardable(REASON_EFFECT)
end
function c100911017.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c100911017.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100911017.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,c100911017.filter,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c100911017.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_XYZ) and tc:GetOriginalRace()==RACE_BEASTWARRIOR
			and tc:GetFlagEffect(100911017)==0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(100911017,1))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PIERCE)
			e1:SetCondition(c100911017.condition)
			tc:RegisterEffect(e1,true)
			tc:RegisterFlagEffect(100911017,0,0,1)
		end
		tc=eg:GetNext()
	end
end
function c100911017.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,100911017)
end
